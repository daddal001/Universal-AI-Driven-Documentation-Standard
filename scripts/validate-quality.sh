#!/bin/bash
# docs/standards/scripts/validate-quality.sh
#
# Purpose: Generate a JSON quality report for documentation with real metrics.
# Metrics: Flesch-Kincaid readability, link counts, frontmatter validation.
#
# Usage:
#   ./validate-quality.sh [directory] [output_file]
#   ./validate-quality.sh                           # Defaults: current dir, ./quality_report.json
#   ./validate-quality.sh docs/                     # Scan docs/, output to ./quality_report.json
#   ./validate-quality.sh docs/ reports/quality.json
#
# OS Compatibility: Linux, macOS, Windows (Git Bash/WSL)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
TARGET_DIR="${1:-.}"
REPORT_FILE="${2:-./quality_report.json}"

# Ensure target directory exists
if [[ ! -d "$TARGET_DIR" ]]; then
    echo -e "${RED}Error: Directory '$TARGET_DIR' does not exist.${NC}"
    exit 1
fi

# Ensure output directory exists
OUTPUT_DIR=$(dirname "$REPORT_FILE")
if [[ ! -d "$OUTPUT_DIR" ]] && [[ "$OUTPUT_DIR" != "." ]]; then
    mkdir -p "$OUTPUT_DIR" || {
        echo -e "${RED}Error: Cannot create output directory '$OUTPUT_DIR'.${NC}"
        exit 1
    }
fi

# Function: Count syllables in text (approximation using vowel groups)
# This heuristic counts vowel sequences as syllables, which is ~85-90% accurate
count_syllables() {
    local text="$1"
    # Convert to lowercase, extract words only
    local words=$(echo "$text" | tr '[:upper:]' '[:lower:]' | tr -cs '[:alpha:]' '\n')
    local total=0

    for word in $words; do
        # Skip very short words
        if [[ ${#word} -lt 2 ]]; then
            ((total++))
            continue
        fi

        # Count vowel groups (consecutive vowels count as one syllable)
        local syllables=$(echo "$word" | sed 's/[^aeiou]//g' | sed 's/\(.\)\1*/\1/g' | wc -c)
        syllables=$((syllables - 1))  # Remove trailing newline count

        # Every word has at least 1 syllable
        if [[ $syllables -lt 1 ]]; then
            syllables=1
        fi

        # Adjust for common patterns
        # Words ending in 'e' often have silent e (reduce by 1 if > 1 syllable)
        if [[ "$word" =~ e$ ]] && [[ $syllables -gt 1 ]]; then
            ((syllables--))
        fi

        # Words ending in 'le' after consonant add a syllable
        if [[ "$word" =~ [^aeiou]le$ ]]; then
            ((syllables++))
        fi

        total=$((total + syllables))
    done

    echo $total
}

# Function: Count sentences (periods, question marks, exclamation points)
count_sentences() {
    local text="$1"
    # Count sentence-ending punctuation, minimum 1
    local count=$(echo "$text" | grep -o '[.!?]' | wc -l)
    if [[ $count -lt 1 ]]; then
        count=1
    fi
    echo $count
}

# Function: Calculate Flesch Reading Ease
# Formula: 206.835 - 1.015 × (words/sentences) - 84.6 × (syllables/words)
calculate_flesch_ease() {
    local words=$1
    local sentences=$2
    local syllables=$3

    if [[ $words -eq 0 ]] || [[ $sentences -eq 0 ]]; then
        echo "0"
        return
    fi

    # Use awk for floating-point math
    echo "$words $sentences $syllables" | awk '{
        words = $1
        sentences = $2
        syllables = $3
        score = 206.835 - (1.015 * (words / sentences)) - (84.6 * (syllables / words))
        if (score < 0) score = 0
        if (score > 100) score = 100
        printf "%.1f", score
    }'
}

# Function: Calculate Flesch-Kincaid Grade Level
# Formula: 0.39 × (words/sentences) + 11.8 × (syllables/words) - 15.59
calculate_fk_grade() {
    local words=$1
    local sentences=$2
    local syllables=$3

    if [[ $words -eq 0 ]] || [[ $sentences -eq 0 ]]; then
        echo "0"
        return
    fi

    echo "$words $sentences $syllables" | awk '{
        words = $1
        sentences = $2
        syllables = $3
        grade = (0.39 * (words / sentences)) + (11.8 * (syllables / words)) - 15.59
        if (grade < 0) grade = 0
        printf "%.1f", grade
    }'
}

# Function: Get readability interpretation
interpret_readability() {
    local score=$1
    if (( $(echo "$score >= 90" | bc -l 2>/dev/null || echo "0") )); then
        echo "Very Easy (5th grade)"
    elif (( $(echo "$score >= 80" | bc -l 2>/dev/null || echo "0") )); then
        echo "Easy (6th grade)"
    elif (( $(echo "$score >= 70" | bc -l 2>/dev/null || echo "0") )); then
        echo "Fairly Easy (7th grade)"
    elif (( $(echo "$score >= 60" | bc -l 2>/dev/null || echo "0") )); then
        echo "Standard (8th-9th grade)"
    elif (( $(echo "$score >= 50" | bc -l 2>/dev/null || echo "0") )); then
        echo "Fairly Difficult (10th-12th grade)"
    elif (( $(echo "$score >= 30" | bc -l 2>/dev/null || echo "0") )); then
        echo "Difficult (College)"
    else
        echo "Very Difficult (College Graduate)"
    fi
}

# Start report
echo -e "${GREEN}Generating documentation quality report...${NC}"
echo -e "Scanning: ${YELLOW}$TARGET_DIR${NC}"
echo ""

# Initialize JSON report
echo "[" > "$REPORT_FILE"

# Find all markdown files
FILES=$(find "$TARGET_DIR" -type f -name "*.md" ! -path "*/node_modules/*" 2>/dev/null | sort)
FILE_COUNT=$(echo "$FILES" | grep -c "\.md$" || echo "0")

if [[ $FILE_COUNT -eq 0 ]]; then
    echo -e "${YELLOW}Warning: No markdown files found in '$TARGET_DIR'.${NC}"
    echo "]" >> "$REPORT_FILE"
    exit 0
fi

echo -e "Found ${GREEN}$FILE_COUNT${NC} markdown files"
echo ""

FIRST=1
TOTAL_WORDS=0
TOTAL_FILES=0
LOW_READABILITY_COUNT=0

for FILE in $FILES; do
    if [[ $FIRST -eq 0 ]]; then
        echo "," >> "$REPORT_FILE"
    fi
    FIRST=0
    ((TOTAL_FILES++))

    # Extract file content (strip code blocks for readability analysis)
    CONTENT=$(cat "$FILE" | sed '/^```/,/^```$/d' | sed 's/^#.*//g')

    # Count words
    WORD_COUNT=$(echo "$CONTENT" | wc -w | tr -d ' ')
    TOTAL_WORDS=$((TOTAL_WORDS + WORD_COUNT))

    # Count sentences
    SENTENCE_COUNT=$(count_sentences "$CONTENT")

    # Count syllables (for files under 10000 words to avoid performance issues)
    if [[ $WORD_COUNT -lt 10000 ]]; then
        SYLLABLE_COUNT=$(count_syllables "$CONTENT")
    else
        # Estimate: average 1.5 syllables per word for English
        SYLLABLE_COUNT=$((WORD_COUNT * 15 / 10))
    fi

    # Calculate readability scores
    FLESCH_EASE=$(calculate_flesch_ease $WORD_COUNT $SENTENCE_COUNT $SYLLABLE_COUNT)
    FK_GRADE=$(calculate_fk_grade $WORD_COUNT $SENTENCE_COUNT $SYLLABLE_COUNT)

    # Track low readability files
    if (( $(echo "$FLESCH_EASE < 30" | bc -l 2>/dev/null || echo "0") )); then
        ((LOW_READABILITY_COUNT++))
    fi

    # Count links
    LINK_COUNT=$(grep -cE 'https?://' "$FILE" 2>/dev/null || echo "0")

    # Check frontmatter
    HAS_FM="false"
    if head -n 1 "$FILE" | grep -q "^\-\-\-"; then
        HAS_FM="true"
    fi

    # Check for required frontmatter fields
    FM_FIELDS=""
    if [[ "$HAS_FM" == "true" ]]; then
        FM_CONTENT=$(sed -n '/^---$/,/^---$/p' "$FILE" | head -20)
        HAS_TITLE=$(echo "$FM_CONTENT" | grep -c "^title:" || echo "0")
        HAS_STATUS=$(echo "$FM_CONTENT" | grep -c "^status:" || echo "0")
        HAS_OWNER=$(echo "$FM_CONTENT" | grep -c "^owner:" || echo "0")
        FM_FIELDS="{\"title\": $([[ $HAS_TITLE -gt 0 ]] && echo "true" || echo "false"), \"status\": $([[ $HAS_STATUS -gt 0 ]] && echo "true" || echo "false"), \"owner\": $([[ $HAS_OWNER -gt 0 ]] && echo "true" || echo "false")}"
    else
        FM_FIELDS="{\"title\": false, \"status\": false, \"owner\": false}"
    fi

    # Relative path for cleaner output
    REL_PATH="${FILE#$TARGET_DIR/}"
    [[ "$REL_PATH" == "$FILE" ]] && REL_PATH="$FILE"

    # Write JSON entry
    cat >> "$REPORT_FILE" << EOF
  {
    "file": "$REL_PATH",
    "metrics": {
      "word_count": $WORD_COUNT,
      "sentence_count": $SENTENCE_COUNT,
      "syllable_count": $SYLLABLE_COUNT,
      "link_count": $LINK_COUNT
    },
    "readability": {
      "flesch_ease": $FLESCH_EASE,
      "fk_grade_level": $FK_GRADE
    },
    "frontmatter": {
      "present": $HAS_FM,
      "fields": $FM_FIELDS
    }
  }
EOF

    # Progress indicator (every 10 files)
    if [[ $((TOTAL_FILES % 10)) -eq 0 ]]; then
        echo -e "  Processed ${GREEN}$TOTAL_FILES${NC} files..."
    fi
done

echo "" >> "$REPORT_FILE"
echo "]" >> "$REPORT_FILE"

# Summary
echo ""
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Quality Report Summary${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════${NC}"
echo -e "  Files analyzed:        ${GREEN}$TOTAL_FILES${NC}"
echo -e "  Total words:           ${GREEN}$TOTAL_WORDS${NC}"
echo -e "  Low readability files: ${YELLOW}$LOW_READABILITY_COUNT${NC} (Flesch < 30)"
echo -e "  Report saved to:       ${GREEN}$REPORT_FILE${NC}"
echo ""

# Exit with error if too many low-readability files
if [[ $LOW_READABILITY_COUNT -gt $((TOTAL_FILES / 4)) ]]; then
    echo -e "${YELLOW}Warning: More than 25% of files have low readability scores.${NC}"
    echo -e "${YELLOW}Consider simplifying complex documentation.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Quality report generated successfully!${NC}"
exit 0
