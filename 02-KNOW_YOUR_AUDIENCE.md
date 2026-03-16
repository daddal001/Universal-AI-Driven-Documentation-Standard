---
title: "Know Your Audience"
type: "standard"
status: "approved"
classification: "public"
owner: "@documentation-maintainer"
created: "2025-12-09"
last_updated: "2026-03-15"
version: "2.0.0"
---

# Know Your Audience

> **Goal:** Write documentation that reaches the people who actually need it, humans and AI agents alike. Every recommendation here is backed by a published source. If you think one is wrong, check the [references](#14-sources-and-references) before opening an issue.

---

## 1. Why this matters

You wrote great docs. Nobody can use them. The problem isn't the content, it's that you wrote them for yourself.

The [Google SWE Book](https://abseil.io/resources/swe-book/html/ch10.html) nails it: "One of the most important mistakes that engineers make when writing documentation is to write only for themselves." Your audience is standing where you once stood, but without your domain knowledge. If you don't account for that gap, your docs are just notes to future-you, and future-you won't need them.

This isn't just a quality issue, it costs real engineering time. [DX research](https://getdx.com/blog/developer-documentation/) found documentation problems eat **15–25% of engineering capacity**. That's 15–25 engineers per 100-person team compensating for docs that weren't written for their actual readers. [NNg](https://www.nngroup.com/articles/writing-for-lower-literacy-users/) showed that rewriting content for its real audience improved task success for *everyone*, even higher-literacy users went from 68% to 93%.

The fix is straightforward: before you write anything, figure out who's reading it and what they need. The rest of this standard shows you how.

---

## 2. Identify your readers

Before writing, answer four questions:

1. **Who will read this?** — Role, experience level, domain knowledge.
2. **What do they already know?** — This determines what you can skip and what you need to explain. A senior engineer who built the system needs different context than a new hire on day two.
3. **What are they trying to accomplish?** — Not "read the docs." Their actual task. Deploy a service. Debug an error. Evaluate a vendor.
4. **How will they find this?** — Search, a link from another doc, scanning a table of contents, or retrieved by an AI agent.

### Audience dimensions

| Dimension | Low end | High end | Why it matters |
|-----------|---------|----------|----------------|
| **Experience level** | Junior engineer, first day | Principal engineer, 20 years | Help for juniors hurts seniors — [section 3](#3-one-doc-cant-serve-everyone) |
| **Domain knowledge** | Knows nothing about your system | Built it | Determines how much context to provide |
| **Task urgency** | Exploring, evaluating | Production is down | Determines tone and structure — [section 7](#7-tone-by-audience-and-context) |
| **Reading mode** | Linear, learning | Scanning for one answer | Determines formatting — [section 5](#5-how-people-actually-read) |
| **Language** | Non-native English speaker | Native speaker, domain expert | Determines vocabulary complexity — [section 10](#10-internationalization-and-global-audiences) |
| **Reader type** | Human | AI agent / LLM | Determines structural requirements — [section 9](#9-ai-agents-as-an-audience) |

---

## 3. One doc can't serve everyone

This is the thing most teams get wrong. They write one document and expect it to work for everyone from the new hire to the staff engineer. It won't.

The research backs this up, [Kalyuga et al.](https://doi.org/10.1207/S15326985EP3801_4) showed that detailed step-by-step explanations and worked examples (the stuff that helps beginners) **actively slow down experienced readers**. It's not that experts are impatient. It's that they've already internalized the concepts, and forcing them to re-process information they already know wastes their time and breaks their flow. The researchers called it the "expertise reversal effect", what helps novices literally hurts experts.

The implication: **a document optimized for novices will frustrate experts. A document optimized for experts will lose novices.** You have to choose, or you have to layer.

### What to do about it

| Strategy | How it works | When to use it | Source |
|----------|-------------|----------------|--------|
| **Separate documents** | Different docs for different audiences | When audiences have fundamentally different needs | [Google SWE Book](https://abseil.io/resources/swe-book/html/ch10.html) (customer vs. provider) |
| **Progressive disclosure** | Show basics first, details on demand — collapsible sections, "Advanced" links | When audiences overlap but need different depth | [NNg](https://www.nngroup.com/articles/progressive-disclosure/), [ISO/IEC/IEEE 26514](https://www.iso.org/standard/77451.html) |
| **Proficiency markers** | Label sections: beginner / intermediate / advanced | When a single doc must serve multiple levels | AWS 100–400 level system (widely used across re:Invent, Skill Builder, and AWS training) |
| **Conditional content** | Publish different versions from a single source | Enterprise / large-scale doc systems | [DITA audience profiling](https://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/condproc.html) |

Progressive disclosure is usually the right call. [NNg](https://www.nngroup.com/articles/progressive-disclosure/) found it improves learnability, efficiency, and error rate — three of usability's five components. Keep it to **2–3 levels**. Deeper nesting creates its own mess.

---

## 4. Seekers vs stumblers

The [Google SWE Book](https://abseil.io/resources/swe-book/html/ch10.html) identifies two reader types. Once you see this, you can't unsee it:

| Type | Who they are | What they need | Design for |
|------|-------------|---------------|------------|
| **Seekers** | Know exactly what they want. Scanning to find it. | Consistency — same format, predictable structure, scannable headings. | Tables, Ctrl+F-friendly text, consistent heading hierarchy, descriptive (not clever) headers. |
| **Stumblers** | Don't know exactly what they want. Have a vague idea. | Clarity — overviews, purpose statements, context-setting. | TL;DR summaries, "Overview" sections at the top, links to related concepts, the "why" before the "how." |

This maps to how people actually navigate information. [Pirolli & Card](https://doi.org/10.1037/0033-295X.106.4.643) coined the term **information scent** — the cues in headings, link text, and summaries that signal whether a page has what you need. Users follow the scent. If it's weak, they leave. If it's strong, they dive in.

### Make your docs smell right

Every page needs to signal its contents within seconds. If readers can't tell whether your page answers their question, they'll bounce.

- **Headings** describe what the section contains. "Configure database connection pooling" — not "Database considerations."
- **Link text** is descriptive. "See the [API authentication guide](./auth.md)" — not "See [here](./auth.md)."
- **Opening paragraphs** answer: what is this, who is it for, what will you learn.
- **Table of contents** entries match the reader's mental query — the words they'd search for.

[NNg](https://www.nngroup.com/articles/information-scent/) found four elements shape information scent: the link label (most critical), surrounding content, page context, and the reader's prior knowledge. You control the first three.

---

## 5. How people actually read

They don't. Not in the way you think.

[NNg](https://www.nngroup.com/articles/how-users-read-on-the-web/) found that **79% of users scan** any new page; only 16% read word-by-word. On average, users [read at most 28% of the words](https://www.nngroup.com/articles/how-little-do-users-read/) on a page — 20% is more realistic. They spend only 4.4 additional seconds for every 100 extra words. Users read half the content only on pages with **111 words or fewer**.

That beautiful three-paragraph explanation you spent an hour writing? Most readers are skipping it entirely.

### Scanning patterns

| Pattern | What happens | When it occurs | Quality |
|---------|-------------|----------------|---------|
| **F-pattern** | Eyes scan across the top, shorter scan partway down, then skim the left edge | Text lacks formatting — no bullets, no bold, no subheadings | Low efficiency — [NNg](https://www.nngroup.com/articles/f-shaped-pattern-reading-web-content/) |
| **Layer-cake** | Eyes jump directly to headings, dip into body text selectively | Well-structured docs with descriptive subheadings | High efficiency — [NNg](https://www.nngroup.com/articles/layer-cake-pattern-scanning/) |

You want the layer-cake pattern. It happens when your headings are **descriptive of all topics in the section, and only topics in the section.** Here's how:

- **Front-load important words** in headings and paragraphs. First lines get more eyeball time than subsequent lines. First words on the left get more than words on the right.
- **Use bullet points and tables** for reference information. Save prose for explanation.
- **Bold key terms** — but sparingly. If everything is bold, nothing is.
- **Keep paragraphs short.** 3–5 sentences. Wall-of-text paragraphs get skipped entirely.

NNg tested rewriting the same content three different ways. The results are hard to argue with:

| Approach | Usability improvement |
|----------|----------------------|
| Concise text | 58% |
| Scannable layout | 47% |
| Objective language | 27% |
| **All three combined** | **124%** |

---

## 6. Customers vs providers

The [Google SWE Book](https://abseil.io/resources/swe-book/html/ch10.html) draws a line between two audiences that should never share a document:

| Type | Who they are | What they need | What they don't need |
|------|-------------|---------------|---------------------|
| **Customers** | API consumers, external developers, users of your system | Usage examples, getting started guides, endpoint docs | Implementation details, internal architecture, design rationale |
| **Providers** | Team members, maintainers, on-call engineers | Architecture decisions, internal details, operational runbooks | Basic usage tutorials, "what is an API" explanations |

### Keep them separate

Mixing them creates a document that serves nobody well. Customers wade through implementation details they don't care about. Providers scan past usage tutorials trying to find the architecture section. Both waste time.

**Wrong — mixed audiences:**

```markdown
# Auth Service

This service uses JWT tokens signed with RS256. The signing keys rotate
every 90 days via a cron job in the key-management service...
[3 paragraphs of implementation details]

## API Usage
POST /auth/login with username and password...
```

**Right — separated:**

```markdown
# Auth Service — API Reference (for consumers)
→ See [API Reference](./api/)

# Auth Service — Architecture (for maintainers)
→ See [Architecture](./ARCHITECTURE.md)
```

This matters even more for AI agents. When an agent retrieves docs to generate code, it needs usage examples and API contracts — not your internal architecture rationale. When it's helping you refactor internals, it needs the opposite. Mixed docs force the agent to sort through irrelevant context, wasting its context window and increasing hallucination risk.

---

## 7. Tone by audience and context

Different docs need different tones. A runbook during an incident is not the place for personality, and an API reference is not the place for encouragement. The [Diataxis framework](https://diataxis.fr/) maps this well, and [NNg's tone research](https://www.nngroup.com/articles/tone-voice-users/) proved it matters — 52% of desirability scores came from trustworthiness.

| Document type | Reader mode | Tone | Why | Source |
|---------------|------------|------|-----|--------|
| Tutorial / Getting Started | Learning | Encouraging, collaborative | ["The first-person plural affirms the relationship between tutor and learner."](https://diataxis.fr/tutorials/) | [Diataxis](https://diataxis.fr/) |
| How-To Guide | Doing a task | Practical, imperative | ["Action and only action."](https://diataxis.fr/how-to-guides/) | [Diataxis](https://diataxis.fr/) |
| API Reference | Looking something up | Neutral, precise | ["Austere and uncompromising... neutrality, objectivity, factuality."](https://diataxis.fr/reference/) | [Diataxis](https://diataxis.fr/) |
| Architecture / ADR | Understanding | Analytical, discursive | ["Admit opinion and perspective."](https://diataxis.fr/explanation/) | [Diataxis](https://diataxis.fr/) |
| Runbook / Incident | Under pressure | Urgent, imperative | Clarity saves time when production is down. | Industry practice |
| Troubleshooting | Stuck, frustrated | Empathetic, direct | Sound like ["a knowledgeable friend."](https://developers.google.com/style/tone) | [Google](https://developers.google.com/style/tone) |

### Don't over-explain

John Carroll's [minimalist instruction](https://www.instructionaldesign.org/theories/minimalism/) research showed something that should change how you think about docs: **25 task-focused cards replaced a 94-page manual**, and users learned twice as fast. His insight was simple — people aren't blank slates. They arrive with existing knowledge. Don't ignore it.

The principles:

1. Start with meaningful tasks — don't make people read background before they can do anything.
2. Let readers fill knowledge gaps from their own experience — don't spell out everything.
3. Include error recognition and recovery — don't just show the happy path.
4. Keep sections independent — let people read them in any order.

Documentation that over-explains for experts or under-explains for novices fails both. That's why [section 3](#3-one-doc-cant-serve-everyone) exists.

---

## 8. Personas and jobs to be done

Two frameworks help you think about who's reading and why. [NNg recommends using both](https://www.nngroup.com/articles/personas-jobs-be-done/) — personas tell you *who* the reader is, Jobs to Be Done (JTBD) tells you *what they're trying to accomplish*.

### Personas

A [persona](https://www.nngroup.com/articles/persona/) is a fictional but realistic description of a typical reader. Ideally based on real data — support tickets, user interviews, analytics. Even quick "assumptive" personas (your best guess without formal research) are better than nothing. [Redish](https://redish.net/books/letting-go-of-the-words/) makes this point well.

**Example personas for a platform team:**

| Persona | Role | Experience | Typical task | What they need from docs |
|---------|------|-----------|-------------|--------------------------|
| **New hire Nia** | Backend engineer, week 2 | Junior, unfamiliar with the stack | Set up local dev environment | Step-by-step with prerequisites, expected output, glossary links |
| **Senior Sam** | Staff engineer, 5 years on the team | Expert in the system | Evaluate a new caching strategy | Architecture docs, ADRs, performance data — skip the basics |
| **Ops Omar** | SRE, on-call | Deep ops knowledge, less code familiarity | Diagnose a 3 AM page | Runbook with exact commands, escalation paths, no theory |
| **PM Priya** | Product manager | Non-technical | Understand capabilities for roadmap planning | Architecture overview, diagrams, business-impact summaries |
| **Agent Ada** | AI coding assistant | No memory between sessions, literal interpretation | Generate code that fits the project | Structured context, explicit constraints, self-contained sections — [section 9](#9-ai-agents-as-an-audience) |

### Jobs to be done

JTBD shifts focus from "what documentation should we write" to "what are readers trying to accomplish." Nobody *wants* to read documentation. They hire it to get a job done.

**Format:** *When [situation], I want to [motivation], so I can [expected outcome].*

| Job | Persona | Document type |
|-----|---------|--------------|
| "When I join the team, I want to set up my dev environment, so I can start contributing." | New hire Nia | Getting started guide |
| "When I'm evaluating a technology choice, I want to understand past decisions, so I can avoid re-litigating settled questions." | Senior Sam | ADR |
| "When production is down, I want exact steps to restore service, so I can resolve the incident." | Ops Omar | Runbook |
| "When I'm building a feature, I want the AI agent to understand our conventions, so I can get production-ready code." | Any developer + Agent Ada | AGENTS.md, llms.txt |

### Writing for each persona

**For new engineers (Nia):**

- Start with prerequisites — list exact versions, tools, access needed.
- Assume nothing about previous knowledge.
- Provide complete, copy-paste examples with expected output.
- Link to glossary for domain terms.
- Scaffold — support them through tasks slightly beyond their current ability, then back off as they get comfortable. This is [Vygotsky's ZPD](https://www.simplypsychology.org/zone-of-proximal-development.html) applied to docs, and it works.

**For senior engineers (Sam):**

- Be concise. Skip the basics.
- Jump to technical details, edge cases, and gotchas.
- Show code patterns, not step-by-step walkthroughs.
- Back your claims. Experts scrutinize. [NNg](https://www.nngroup.com/articles/writing-domain-experts/) found they demand references: "Wild statements do not lead one to credibility."
- Keep it current. Experts reject stale docs: "Some things may be lost if they're not current within six months or a year."

**For non-technical stakeholders (Priya):**

- Lead with business value, not technical detail.
- Use diagrams over text — people recall information better when it's presented [visually and verbally](https://www.instructionaldesign.org/theories/dual-coding/) together.
- Avoid jargon or define it immediately.
- Summarize in bullet points.

---

## 9. AI agents as an audience

Documentation now has two classes of readers: humans and machines. This isn't theoretical — the [2024 Stack Overflow Developer Survey](https://survey.stackoverflow.co/2024/) found that 81% of developers expect AI tools to become more integrated in how they consume code. *AGENTS.md* has been adopted by over 20,000 GitHub repositories.

AI agents are the ultimate "every page is page one" readers ([Baker, 2013](https://everypageispageone.com/the-book/)). They arrive at documentation fragments through retrieval, never through sequential navigation. They can't see your visual layout. They process text literally.

### How AI agents differ from humans

| Dimension | Human reader | AI agent | What to do |
|-----------|-------------|----------|------------|
| **Navigation** | Follows links, scans visually | Retrieves chunks via embeddings or search | Make every section self-contained |
| **Context** | Builds understanding across a session | Context window is finite and per-request | Don't write "see above" — restate what's needed |
| **Ambiguity** | Resolves from layout, tone, experience | Hallucinates through it | Be explicit — [Redocly](https://redocly.com/blog/optimizations-to-make-to-your-docs-for-llms) found vague pronoun references force probabilistic guesses |
| **Visual hierarchy** | Uses bold, color, indentation | Can't interpret visual formatting | Heading hierarchy *is* the structure — don't skip levels |
| **Terminology** | Infers synonyms from context | Must guess if different terms mean different things | One term per concept, everywhere |
| **Memory** | Recalls previous sessions | Fresh context each time, [CLAUDE.md](https://code.claude.com/docs/en/memory) | Instruction files must reload each session |

### Six rules for AI-readable docs

1. **Strict heading hierarchy.** Don't skip from H2 to H4. AI agents build structural models from heading levels — skipping breaks them. ([Redocly](https://redocly.com/blog/optimizations-to-make-to-your-docs-for-llms))
2. **One term per concept.** If you call it "PostgreSQL" in one section and "Postgres" in another, an AI has to guess whether they're the same thing. It might guess wrong.
3. **Fenced code blocks with language tags.** This enables reliable extraction and correct syntax interpretation.
4. **Self-contained sections.** An AI agent may retrieve only one section. If it starts with "As mentioned above..." the agent has zero context.
5. **Text alternatives for visuals.** AI agents can't interpret diagrams or screenshots without descriptive alt text.
6. **Concrete constraints.** "Use 2-space indentation" beats "format code properly." Specific, verifiable instructions produce better output. ([Anthropic](https://www.anthropic.com/research/building-effective-agents))

### Machine-readable context files

| File | Purpose | Spec |
|------|---------|------|
| **llms.txt** | Project summary optimized for AI consumption — Markdown, strict structure, links to detail pages | [llmstxt.org](https://llmstxt.org/) |
| **AGENTS.md** | Coding rules and project conventions for AI agents | *agents-md*|
| **CLAUDE.md** | Persistent instructions for Claude Code, scoped to project/user/org | [Anthropic docs](https://code.claude.com/docs/en/memory) |

[Fern](https://buildwithfern.com/post/optimizing-api-docs-ai-agents-llms-txt-guide) reported **over 90% reduction in token consumption** when serving llms.txt compared to raw HTML pages. AI assistants "exhaust token budgets on navigation, styling, and JavaScript before reaching actual endpoint details" when consuming HTML.

Here's the good news: everything that makes docs better for AI agents — explicit structure, consistent terminology, self-contained sections, descriptive headings — also makes them better for humans. You're not trading off one audience for the other. You're improving for both.

---

## 10. Internationalization and global audiences

Your docs almost certainly have non-native English speakers in the audience. If they do, vocabulary control isn't optional. The [Simplified Technical English standard (ASD-STE100)](https://asd-ste100.org/) has been used in aerospace since the 1970s and became an international standard in 2025. You don't need to adopt it wholesale, but the principles are sound:

| Guideline | Example | Source |
|-----------|---------|--------|
| Use simple, direct words | "start" not "commence", "use" not "utilize" | [Google — Translation](https://developers.google.com/style/translation) |
| Write shorter sentences | Target 15–20 words per sentence | [NNg](https://www.nngroup.com/articles/plain-language-experts/) |
| Avoid phrasal verbs | "configure" not "set up" (exceptions: established terms like "log in") | [Google — Translation](https://developers.google.com/style/translation) |
| Avoid idioms and cultural references | "the process failed" not "the process fell flat" | [Google — Translation](https://developers.google.com/style/translation) |
| Define abbreviations on first use | "Architecture Decision Record (ADR)" | [Google — Abbreviations](https://developers.google.com/style/abbreviations) |
| Conditions before instructions | "If you're ready, select Submit" not "Select Submit if you're ready" | [Google — Highlights](https://developers.google.com/style/highlights) |

Controlled language helps three audiences at once: non-native speakers who struggle with idioms, AI agents that process text literally, and machine translation systems that produce better output from simpler input.

### Readability targets

| Audience | Target reading level | Source |
|----------|---------------------|--------|
| General / landing pages | Grade 6–8 | [NNg](https://www.nngroup.com/articles/plain-language-experts/) |
| Developer docs | Grade 8–10 | Industry practice |
| Expert / internal | Grade 10–12 | [NNg](https://www.nngroup.com/articles/plain-language-experts/) |
| WCAG AAA compliance | Lower secondary (~Grade 9) | [WCAG 3.1.5](https://www.w3.org/WAI/WCAG21/Understanding/reading-level.html) |

And before someone argues that experts need complex language — [NNg](https://www.nngroup.com/articles/plain-language-experts/) tested this. Highly educated professionals chose the simpler version every time. An IT manager: "This is short, easy to digest. It gives a very clear picture." Nobody has ever complained that a text was too easy to understand.

---

## 11. TL;DR and entry points

Start most documents with a summary that helps readers decide if they're in the right place. This respects their time — if the scent is wrong, let them leave fast.

### When to use a TL;DR

| Document type | TL;DR? | Why |
|---------------|--------|-----|
| Tutorial | Yes | Help readers decide if it's the right level |
| Architecture doc | Yes | Summarize key decisions up front |
| API Reference | Sometimes | For complex APIs with many endpoints |
| Runbook | No | Start with the fix, not a summary |
| ADR | Yes | The decision and status should be visible immediately |

### The 5 Ws in your introduction

Every introduction should answer WHO, WHAT, WHEN, WHERE, and WHY — but naturally, not as labeled fields.

**Wrong — mechanical labels:**

```markdown
# Database Connection Pooling

> **WHO:** Backend engineers
> **WHAT:** Database connection pooling configuration
> **WHEN:** Last updated Dec 2025, review quarterly
> **WHERE:** Part of infrastructure documentation
> **WHY:** Proper pooling prevents connection exhaustion under load
```

**Right — natural prose that answers all five:**

```markdown
# Database connection pooling

This guide helps backend engineers configure connection pooling
for PostgreSQL databases. Proper pooling prevents connection
exhaustion under load — a common cause of production outages.

Use this when setting up a new service or troubleshooting
connection errors. Last reviewed December 2025.
```

Same information. One reads like a form. The other reads like a person wrote it.

---

## 12. Don't organize by audience

This is counterintuitive, but audience-based navigation ("Beginners click here, Advanced users click here") fails in practice. [NNg](https://www.nngroup.com/articles/audience-based-navigation/) identified five reasons:

1. **People struggle to self-categorize.** "Am I a beginner or intermediate?"
2. **Labels are ambiguous.** Is "Administrators" *for* admins or *about* admins?
3. **Self-identification adds cognitive load.** Another decision before the reader even reaches content.
4. **People worry they're missing content** in the other sections.
5. **Overlapping content creates duplicates** that go stale at different rates.

**Instead:** organize by topic or task. Use progressive disclosure within topics to serve different expertise levels. Label sections by proficiency where you need to (beginner / intermediate / advanced), but keep them in the same navigation hierarchy.

Kubernetes does this well. Their docs use four content types — [concept, task, tutorial, and reference](https://kubernetes.io/docs/contribute/style/page-content-types/) — not audience labels. A concept page serves anyone who needs to understand a topic. A task page serves anyone who needs to do a specific thing. The reader self-selects by choosing the content type that matches their need right now.

---

## 13. Validate your assumptions

Writing for your audience is a hypothesis. If you don't validate it, you're guessing.

### Quantitative signals

| Signal | What it tells you | Tool |
|--------|-------------------|------|
| Page bounce rate | Readers didn't find what they expected (weak information scent) | Analytics |
| Time on page vs. word count | Whether readers are actually reading or scanning and leaving | Analytics |
| Search queries leading to zero results | Gaps between reader vocabulary and your terminology | Search analytics |
| Support tickets about documented topics | Docs aren't reaching their audience or aren't answering their questions | Support system |
| AI agent hallucination on documented topics | Machine-readable structure is insufficient | Manual review |

### Qualitative methods

| Method | What it reveals | Source |
|--------|----------------|--------|
| **Friction logs** | Use your own product and docs end-to-end, note every point of confusion | [Docs for Developers](https://www.goodreads.com/book/show/58278048-docs-for-developers) (Bhatti et al.) |
| **Cloze tests** | Replace every 6th word with a blank. If your target readers can't fill 60%+ correctly, the text is too complex for them. | [NNg](https://www.nngroup.com/articles/cloze-test-reading-comprehension/) |
| **Per-page feedback** | Thumbs-up/down or star rating on each page, routed to the authoring team | [Twilio](https://www.twilio.com/en-us/blog/new-era-for-twilio-documentation) uses Slack-integrated ratings |
| **User interviews** | Talk to actual readers — what were they trying to do, what did they find, what did they miss | [Redish](https://redish.net/books/letting-go-of-the-words/) |

[Stripe](https://stripe.com/blog/markdoc) treats docs as a product: features aren't shipped until docs are written, reviewed, and published. Documentation is in their engineering career ladders. That's how you make sure docs actually reach their audience — you make it part of the job, not an afterthought.

---

## 14. Sources and references

### Books and foundational texts

| # | Source | URL / Citation |
|---|--------|----------------|
| 1 | Winters, Manshreck, Wright — *Software Engineering at Google*, Ch. 10: Documentation | <https://abseil.io/resources/swe-book/html/ch10.html> |
| 2 | Carroll — *The Nurnberg Funnel: Designing Minimalist Instruction*, MIT Press, 1990 | — |
| 3 | Redish — *Letting Go of the Words*, 2nd ed., Morgan Kaufmann, 2012 | <https://redish.net/books/letting-go-of-the-words/> |
| 4 | Bhatti, Corleissen, Lamber, Quartel, Singer — *Docs for Developers*, Apress, 2021 | <https://www.goodreads.com/book/show/58278048-docs-for-developers> |
| 5 | Baker — *Every Page is Page One*, XML Press, 2013 | <https://everypageispageone.com/the-book/> |
| 6 | Richards — *Content Design*, Content Design London, 2017 | — |

### Academic research

| # | Source | URL / Citation |
|---|--------|----------------|
| 7 | Sweller — "Cognitive load during problem solving," *Cognitive Science* 12(2), 1988 | — |
| 8 | Kalyuga, Ayres, Chandler, Sweller — "The Expertise Reversal Effect," *Educational Psychologist* 38(1), 2003 | <https://doi.org/10.1207/S15326985EP3801_4> |
| 9 | Pirolli & Card — "Information Foraging," *Psychological Review* 106(4), 1999 | <https://doi.org/10.1037/0033-295X.106.4.643> |

### Nielsen Norman Group research

| # | Source | URL |
|---|--------|-----|
| 10 | How Users Read on the Web | <https://www.nngroup.com/articles/how-users-read-on-the-web/> |
| 11 | F-Shaped Pattern Reading | <https://www.nngroup.com/articles/f-shaped-pattern-reading-web-content/> |
| 12 | Layer-Cake Pattern Scanning | <https://www.nngroup.com/articles/layer-cake-pattern-scanning/> |
| 13 | How Little Do Users Read? | <https://www.nngroup.com/articles/how-little-do-users-read/> |
| 14 | Information Foraging | <https://www.nngroup.com/articles/information-foraging/> |
| 15 | Information Scent | <https://www.nngroup.com/articles/information-scent/> |
| 16 | Progressive Disclosure | <https://www.nngroup.com/articles/progressive-disclosure/> |
| 17 | Minimize Cognitive Load | <https://www.nngroup.com/articles/minimize-cognitive-load/> |
| 18 | Plain Language Is for Everyone, Even Experts | <https://www.nngroup.com/articles/plain-language-experts/> |
| 19 | Writing for Lower-Literacy Users | <https://www.nngroup.com/articles/writing-for-lower-literacy-users/> |
| 20 | Writing Digital Copy for Domain Experts | <https://www.nngroup.com/articles/writing-domain-experts/> |
| 21 | Tone of Voice Impact | <https://www.nngroup.com/articles/tone-voice-users/> |
| 22 | Personas Make Users Memorable | <https://www.nngroup.com/articles/persona/> |
| 23 | Personas vs. Jobs-to-Be-Done | <https://www.nngroup.com/articles/personas-jobs-be-done/> |
| 24 | Mental Models | <https://www.nngroup.com/articles/mental-models/> |
| 25 | Audience-Based Navigation: 5 Reasons to Avoid It | <https://www.nngroup.com/articles/audience-based-navigation/> |
| 26 | Cloze Test Reading Comprehension | <https://www.nngroup.com/articles/cloze-test-reading-comprehension/> |
| 27 | Technical Jargon | <https://www.nngroup.com/articles/technical-jargon/> |

### Style guides and standards

| # | Source | URL |
|---|--------|-----|
| 28 | Google Developer Documentation Style Guide | <https://developers.google.com/style> |
| 29 | Google — Tone | <https://developers.google.com/style/tone> |
| 30 | Google — Translation | <https://developers.google.com/style/translation> |
| 31 | Google — Abbreviations | <https://developers.google.com/style/abbreviations> |
| 32 | Google — Highlights | <https://developers.google.com/style/highlights> |
| 33 | Microsoft Writing Style Guide | <https://learn.microsoft.com/en-us/style-guide/welcome/> |
| 34 | Kubernetes Page Content Types | <https://kubernetes.io/docs/contribute/style/page-content-types/> |
| 35 | Diataxis Framework | <https://diataxis.fr/> |
| 36 | ISO/IEC/IEEE 26514:2022 — Design and development of information for users | <https://www.iso.org/standard/77451.html> |
| 37 | ISO/IEC/IEEE 26511:2018 — Requirements for managers of information for users | <https://www.iso.org/standard/70879.html> |
| 38 | WCAG 3.1.5 — Reading Level | <https://www.w3.org/WAI/WCAG21/Understanding/reading-level.html> |
| 39 | ASD-STE100 — Simplified Technical English | <https://asd-ste100.org/> |
| 40 | DITA — Conditional Processing | <https://docs.oasis-open.org/dita/v1.2/os/spec/archSpec/condproc.html> |

### AI and machine-readable documentation

| # | Source | URL |
|---|--------|-----|
| 41 | llms.txt Specification | <https://llmstxt.org/> |
| 42 | AGENTS.md | <https://github.com/anthropics/agents-md> |
| 43 | Anthropic — CLAUDE.md / Memory | <https://code.claude.com/docs/en/memory> |
| 44 | Anthropic — Building Effective Agents | <https://www.anthropic.com/research/building-effective-agents> |
| 45 | Redocly — Optimizing Docs for LLMs | <https://redocly.com/blog/optimizations-to-make-to-your-docs-for-llms> |
| 46 | Fern — Optimizing API Docs for AI Agents | <https://buildwithfern.com/post/optimizing-api-docs-ai-agents-llms-txt-guide> |
| 47 | GitHub Copilot Custom Instructions | <https://docs.github.com/en/copilot/customizing-copilot/adding-repository-custom-instructions-for-github-copilot> |
| 48 | DocBench — LLM Document Reading Benchmark | <https://arxiv.org/abs/2407.10701> |

### Industry practices

| # | Source | URL |
|---|--------|-----|
| 49 | Stripe — How Stripe Builds Interactive Docs with Markdoc | <https://stripe.com/blog/markdoc> |
| 50 | Twilio — A New Era for Twilio's Documentation | <https://www.twilio.com/en-us/blog/new-era-for-twilio-documentation> |
| 51 | AWS — 100–400 Content Levels (used across re:Invent, Skill Builder, and AWS training; no permanent canonical URL) | — |
| 52 | Stack Overflow Developer Survey 2024 | <https://survey.stackoverflow.co/2024/> |
| 53 | DX — Developer Documentation Impact | <https://getdx.com/blog/developer-documentation/> |
| 54 | Write the Docs — Documentation Principles | <https://www.writethedocs.org/guide/writing/docs-principles/> |

### Learning theory

| # | Source | URL |
|---|--------|-----|
| 55 | Zone of Proximal Development — Simply Psychology | <https://www.simplypsychology.org/zone-of-proximal-development.html> |
| 56 | Minimalism (Carroll) — Instructional Design | <https://www.instructionaldesign.org/theories/minimalism/> |
| 57 | Dual Coding Theory — Instructional Design | <https://www.instructionaldesign.org/theories/dual-coding/> |

---

## 15. Related documents

| Document | What it covers |
|----------|---------------|
| [Philosophy](./01-PHILOSOPHY.md) | Why documentation matters |
| [Document Types](./03-DOCUMENT_TYPES.md) | What types to write and when |
| [AI Agents](./04-AI_AGENTS.md) | AI assistant configuration and llms.txt |
| [Style Guide](./11-STYLE_GUIDE.md) | Writing style, tooling, and enforcement |
| [Glossary](./GLOSSARY.md) | Term definitions |

---

**Previous:** [01 - Philosophy](./01-PHILOSOPHY.md)
**Next:** [03 - Document Types](./03-DOCUMENT_TYPES.md)
