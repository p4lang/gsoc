# P4 GSoC 2026 Ideas List

## Application process

Please check our [Contributor Guidance](/materials/contributor_guidance.md) for detailed instructions.

## Potential mentors

⭐ = available as primary mentor

1. ⭐
1. 


## FAQ

Note: you = contributors, we = mentors.

**Q1: Some mentors are listed as primary mentor for multiple projects. How does that work?**

For the application phase, we'd like to present more options for you to choose from. Eventually, depending on the applications received, they will decide on at most 1 project to commit to as a primary mentor.

**Q2: What do our project difficulties mean?**

[diffi-easy]: https://img.shields.io/badge/Difficulty-Easy-green
[diffi-medium]: https://img.shields.io/badge/Difficulty-Medium-blue
[diffi-hard]: https://img.shields.io/badge/Difficulty-Hard-red

- ![diffi-easy]: Basic coding skills are sufficient.
- ![diffi-medium]: CS undergraduate level knowledge/skills are required.
- ![diffi-hard]: Deeper and more specialized knowledge/skills are required.

**Q3: Project sizes are specifided in hours. How many weeks do they correspond to?**

[size-s]: https://img.shields.io/badge/Size-90_hour-green
[size-m]: https://img.shields.io/badge/Size-175_hour-blue
[size-l]: https://img.shields.io/badge/Size-350_hour-red

- ![size-s]: 8 weeks
- ![size-m]: 12 weeks
- ![size-l]: 12 weeks

**Q4: Some projects have an "alternative qualification task" section. What does that mean?**

It means for that specific project, instead of the general qualification task, you shall complete the alternative qualification task described in that section.

**Q5: Some "alternative qualification task" section says "demonstrate your XYZ skills through contributions to". What does that mean?**

It means we expect you to have made relevant contributions in order to demonstrate your XYZ skills. In your applicaiton, please briefly describe your contributions, and attach related links (e.g. pull requests on GitHub).

## Project ideas

### Index

- Category: core P4 tooling
  - [Project 1: ](#project-1)
- Category: exploratory P4 tooling
- Category: P4 research
  - [Project N: ](#project-N)


---

### <a name='project-1'></a> Project 1:[⤴️](#index)

**Basic info**

![diffi-easy] ![size-s]

- Potential mentors
  - Primary:
  - Support: 
- Skills
  - Required:
  - Preferred:
- Discussion thread:

**Alternative qualification task**

**Project description**

**Expected outcomes**

**Resources**

---

### <a name='project-N'></a> Project N: Tutorial documentation for P4-SpecTec: A P4 specification mechanization framework [⤴️](#index)

**Basic info**

![diffi-easy] ![size-s]

- Potential mentors
  - Primary: Jaehyun Lee
  - Support: -
- Skills
  - Required: Git, OCaml
  - Preferred: Technical writing, Docker, background in programming languages
- Discussion thread: GitHub issue tracker, Zulip

**Alternative qualification task**

- The P4C compiler has an existing issue regarding compile-time known-ness of directionless action parameters: https://github.com/p4lang/p4c/issues/5405. The same issue is also present in P4-SpecTec. The current mechanized specification blindly treats directionless parameters as compile-time known, without proper checking of whether the directionless parameter is for an action.
- Create a PR to P4-SpecTec that resolves this issue by amending the mechanized specification to properly check for action parameters.

**Project description**

[P4-SpecTec](https://github.com/kaist-plrg/p4-spectec/tree/concrete) is a framework for mechanizing the P4 language specification. Unlike the current official P4-16 language specification which is written in natural language, P4-SpecTec provides a specification language for formally and mechanically defining the syntax and semantics of P4. This approach offers several benefits.

- Ambiguities in natural language specifications can be avoided.
- The specification can be executed and tested against actual P4 programs, thus giving assurance on its correctness.
- The specification can also be processed and transformed into various backend representations. For instance, P4-SpecTec currently offers a [specification document backend](https://kaist-plrg.github.io/p4-spectec/P4-16-spec-new.html) that generates a human-readable specification document from the formal specification.

The goal of P4-SpecTec is to eventually augment, or even replace, the current official P4-16 language specification. For this vision to be realized, it is crucial that P4 developers and researchers can easily understand and use P4-SpecTec. Thus, the goal of this project is to create **comprehensive tutorial documentation** for P4-SpecTec.

To proivde an intuitive understanding of what *mechanized specification* is and how P4-SpecTec works, consider the following example. The snippet below shows an actual mechanized specification for typing P4 conditional statements:

```plaintext
syntax conditionalStatement =
  | IF `( expression ) statement
  | IF `( expression ) statement ELSE statement

relation Stmt_ok:
  cursor typingContext flow |- statement : typingContext flow statementIR
  hint(input %0 %1 %2 %3)
  hint(prose_in "typing" %3#", under cursor" %0#", typing context" %1#", and abstract control flow" %2)
  hint(prose_out "\nthe typing context" %4#",\nthe abstract control flow" %5#",\nand the typed statement" %6)

rulegroup Stmt_ok/conditionalStatement {

  rule Stmt_ok/non-else:
    p TC f |- IF `( expression_cond ) statement_then
            : TC f (IF `( typedExpressionIR_cond ) statementIR_then)
    ---- ;; type check condition expression
    -- Expr_ok: p TC |- expression_cond : typedExpressionIR_cond
    ---- ;; fetch annotation
    ---- ;; the condition must be a boolean type
    -- if typeIR_cond = $type_of_typedExpressionIR(typedExpressionIR_cond)
    -- if BOOL = $canon_typeIR(typeIR_cond)
    ---- ;; check then statement
    -- Stmt_ok: p TC f |- statement_then : TC_then f_then statementIR_then

  rule Stmt_ok/else:
    p TC f |- IF `( expression_cond ) statement_then ELSE statement_else
            : TC f_post (IF `( typedExpressionIR_cond ) statementIR_then
                       ELSE statementIR_else)
    ---- ;; type check condition expression
    -- Expr_ok: p TC |- expression_cond : typedExpressionIR_cond
    ---- ;; fetch annotation
    ---- ;; the condition must be a boolean type
    -- if typeIR_cond = $type_of_typedExpressionIR(typedExpressionIR_cond)
    -- if BOOL = $canon_typeIR(typeIR_cond)
    ---- ;; check then and else statements
    -- Stmt_ok: p TC f |- statement_then : TC_then f_then statementIR_then
    -- Stmt_ok: p TC f |- statement_else : TC_else f_else statementIR_else
    -- if f_post = $join_flow(f_then, f_else)

}
```

The above specification formally defines what is described in Section 12.6 of the current language specification:

> The conditional statement uses standard syntax and semantics familiar from many programming languages. However, the condition expression in P4 is required to be a Boolean (and not an integer).

The mechanized specification is written in terms of inference rules, where each rule corresponds to a small fragment of the overall specification. Rule `non-else` specifies how to type-check an `if` statement without an `else` branch, while rule `else` specifies that of an `if-else` statement. An inference rule is comprised of inputs, premises (the lines prefixed with `--`), and outputs (or results). For the `non-else` rule, the inputs are the typing context `TC`, the cursor `p` indicating the current scope, the return indicator `f`, and the statement `IF ( expression_cond ) statement_then`. Given these inputs, the premises specify the conditions that must hold for the output to be derived. In this case, the premises require that the condition expression type-checks to a Boolean type, and that the `then` statement also type-checks. If these premises are satisfied, we can conclude that the entire `if` statement type-checks as the specified output. 

<img width="700" alt="image" src="assets/p4spectec.jpg">

Additionally, because the specification itself is written in a specification language, it can be executed and tested. That is, if we implement an interpreter for the specification language, we can run the above specification on actual P4 programs. For a mechanized specification of the P4 language type system, this enables type-checking real P4 programs against the formal specification. P4-SpecTec also specifies the dynamic semantics of P4, making it possible to execute P4 programs for a given input packet.

Finally, the specification can be transformed into a human-readable prose document, as illustrated below:

<img width="700" alt="image" src="assets/p4spectec-prose.jpg">

Although P4-SpecTec already provides above features, it is currently difficult for new users to get started with P4-SpecTec due to the lack of tutorial documentation. Thus, in this project, we will create tutorial documentation that helps new users understand what mechanized specification is, how P4-SpecTec works, and how it can be used to extend or modify the P4 language specification.

As a reference, Wasm-SpecTec, a mechanization framework for the WebAssembly (Wasm) language, is already an official Wasm specification authoring toolchain. It includes a hands-on tutorial that guides users through specifying a small subset of Wasm, called nano_wasm. This tutorial walks users through the entire process of writing a mechanized specification, executing it, and generating a human-readable specification document. Inspired by this approach, we will develop similar tutorial documentation for P4-SpecTec, starting with defining a small subset of P4, named nano-P4.

The tutorial documentation is expected to include hands-on examples for nano-P4, as well as Docker images to help users easily set up and use P4-SpecTec.

**Expected outcomes**

- A mechanized specification for nano-P4 using P4-SpecTec.
- Tutorial documentation for P4-SpecTec, describing how to specify nano-P4, execute the specification, and generate a specification document.
- Docker images for easy setup and usage of P4-SpecTec.

**Resources**

- P4-SpecTec repository: https://github.com/kaist-plrg/p4-spectec/tree/concrete
- P4 Developer Day talk on P4-SpecTec: https://youtu.be/2BhqyE7c-Pw?si=NWfp5JAg7nmi8ise
- Reference project: Wasm-SpecTec
  - https://github.com/Wasm-DSL/spectec
  - https://github.com/Wasm-DSL/spectec/tree/main/spectec/doc
