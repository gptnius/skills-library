---
name: article-writing
description: Write long-form articles for X (Twitter) and similar platforms in Michael's house style. Use when the user asks to write, draft, revise, or plan an article, blog post, essay, or long-form piece, or asks for a thread and distribution plan for one. Covers voice rules (no em dashes, no AI tells), structure, fact verification, image prompts, thread strategy, and HTML output for pasting into X.
metadata:
  version: 1.0.0
  author: Michael McLaughlin (gptnius)
  origin: Distilled from the "732 free skills" article build, 2026-07-31
---

# Article Writing: Michael's House Style

Encodes how Michael writes and ships long-form articles. Follow this unless he says otherwise.

## Non-negotiables

**No em dashes. Ever.** He removes them by hand, so don't create the work. Use instead:
- Colon for a definition or list lead-in: `A Skill is just a small text file: a name, a description, and rules.`
- Parentheses for a true aside: `Its debugging skill alone (a real root-cause protocol) pays for itself.`
- Period for a dramatic pivot: `Experts don't average. They have taste.`
- Comma + conjunction for contrast: `Not because it got smarter, but because someone left it instructions.`
- Semicolon sparingly for linked clauses.

**No AI tells.** Never ship: "streamline," "innovative solutions," "delve," "in today's fast-paced world," "unlock the power of," "it's not just X, it's Y," "let's dive in," "game-changer," "revolutionize," "seamless," "robust ecosystem," "at the end of the day." If a sentence could open any LinkedIn post, rewrite it.

**Italics are seasoning, not sauce.** Two or three per article maximum, for genuine emphasis on a single word. He explicitly flagged over-italicizing. Bold is for scannable claims and works harder; prefer it.

**Lead with value, never with risk or warning.** The first draft of the skills article led with a security audit. He was right that it was an insider's angle. Value first, caveats later and calm. Risk sections belong in the back half, framed as "the part I did so you don't have to."

**Verify before you publish.** Check every number, star count, license, name, and claim with a real tool call before it goes in. Never publish a statistic you have not personally confirmed this session. If a fact cannot be verified, cut it or attribute it as a claim.

## Voice

- Short punchy sentence runs for emphasis: `Unsexy. Essential. Automated.`
- Concrete over abstract. "Buttons too small to tap" beats "poor mobile usability."
- Humor is welcome and lands best as deadpan understatement or a callback: `You get the expertise. The scripts stay in the jar.` A well-earned emoji (🤓) is fine once.
- Honest self-disclosure is a feature: `No amount of Skills can give AI your voice.` and `(for better or worse)`. Do not sand these off.
- Credit-forward always. Name the humans, link their work, tell readers to go support them. This is a core value, not a formality.
- Give non-technical readers an on-ramp. Every technical instruction gets a plain-language alternative: `If running commands is outside your comfort zone, just tell your agent to check out the repo at...`
- He capitalizes the artifact noun when it is a proper concept (Skill, Skills). Match whatever convention the current piece establishes and keep it consistent throughout.

## Structure

1. **Title.** Value promise, plain words, specific and concrete. Follow `ogilvy`: promise a benefit, flag the audience, inject news. A number helps ("732 free skills"). Do not cite a word-count rule unless the title obeys it.
2. **Opening paragraph = the X subheadline.** X renders the first sentences as the subheadline under the title and cover image. Write it deliberately for that slot: value promise + scope + what the reader gets. Do not put anything above it.
3. **Intro: problem, reframe, unlock.** Name a pain the reader already feels, reframe it as a default rather than a ceiling, then reveal the mechanism. Keep it to five or six short paragraphs.
4. **The body list, grouped by when you use it,** not by category name. "When you're starting something new" beats "Design Skills." Attribution goes inline in the header: `**skill-name**, by Person`, with the name hyperlinked to their repo.
5. **The honest section.** Safety, caveats, or limitations. Calm, specific, and framed as work already done on the reader's behalf.
6. **Setup or how-to-get-it,** after the value has been sold.
7. **Transparency section.** How AI was used in the piece, with specifics that stay accurate after editing (see Drift check below).
8. **Credits roll.** Everyone who contributed, grouped, with a direct ask to go support them.
9. **CTA with two engagement questions.** One that invites contribution ("What's missing from this list?"), one that invites the reader to talk about themselves ("What's the first thing you're building?"). Add a reciprocity hook: best suggestions get included, with credit. Close with "I read the replies."

## Drift check (learned the hard way)

After any editing pass, re-verify the transparency section against what the article now actually is. In the first article, the "Skills used" section still credited a skill for "the opening hook" after the opening had been rewritten, and cited an 8-to-12-word headline rule that the final 15-word headline broke. Every claim about process must survive the edits that follow it.

## Skills to invoke while writing

- `ogilvy` for the headline and captions (five times as many people read the headline as the body; every image caption is a miniature ad).
- `social` for hook formulas, thread structure, and platform mechanics.
- `marketing-psychology` for framing: curiosity gap, mimetic proof ("the pros already use these"), reciprocity (give before asking).
- `copywriting` + `copy-editing` for the de-buzzwording pass over the finished draft.
- `frontend-design` for image art direction.

Name the skills actually used in the transparency section, with what each one contributed.

## Images: 3 to 4 per article

One cover plus two or three in-body. More than four is clutter; the first build made seven and it was too many.

- **One committed visual system per article.** Pick a palette and a rendering style, state it once, apply it to every prompt. Avoid the AI-default clusters `frontend-design` names: no cream-and-terracotta serif editorial, no near-black-with-acid-green hacker look, no glowing neon circuit brains, no chrome robots.
- **Cover concept sells the thesis,** not the topic. For "taste is installable," the cover was a plain wireframe transforming into a designed page as cards slot in.
- **One image may deliberately break the system** for a comic beat. A realistic photo among illustrations is a strong pattern interrupt.
- **Every image gets a caption written as a miniature ad,** per Ogilvy. Captions are read twice as often as body copy.
- **Text inside images garbles.** Prefer implied text. When a real word matters (a name tag, a label), include a fallback note: generate it blank and set the text in Figma, or use Ideogram.
- Supply a universal negative prompt and per-image aspect ratios (16:9 cover for the X card, 4:5 or 1:1 for in-feed).
- Note alt text for every image.

## Thread and distribution plan

Always include one. Rules learned:

- **The thread sells the click. It never replaces the article.** A thread that summarizes all the value means nobody opens the piece. Tease, prove with one concrete example, link.
- Default to a **single hero post plus an immediate credits reply**. The hero post stays clean for maximum reach; the reply fires the @-mentions so creators still get notified without splitting reach or reading as beg-bait.
- **Hashtags: 1 to 2 per post, at the end only.** Stuffing reads as spam to the algorithm. Rotate rather than repeat.
- **Mentions: 3 per post maximum.**
- **Tag people who actually engage.** Better yet, quote-post a result built with their work a day or two later. Creators reshare results made with their tools far more readily than lists that mention them.
- **Always flag handle verification.** GitHub identity is not X identity. A wrong tag credits a stranger.
- Post the article natively (X favors it over external links), then the hero post, then a proof screenshot as a self-reply about an hour later.
- Reply to every response in the first 24 hours; reply velocity is the ranking signal.

## Output format

**Deliver rich text as HTML, not markdown.** He pastes into X's composer, and markdown symbols have to be stripped by hand. Write a standalone `.html` file with real `<strong>`, `<em>`, `<a href>`, and headings, plus light readable styling. He opens it in a browser and copies from there so formatting survives.

Deliver as separate files: the article HTML, and the distribution plan plus image prompts (markdown is fine for those, they are working documents).

## Process

1. Agree the angle and audience before drafting. Ask who the piece is for if it is not obvious; technical versus general changes everything.
2. Verify all facts with real tool calls.
3. Draft.
4. Editing passes together, out loud, section by section. He will push back on framing, and the pushback is usually right.
5. He does a final personal pass for voice. Expect his edits to tighten and warm the prose; do not undo them in later revisions.
6. Re-run the drift check after his pass.
7. Ship the HTML.
