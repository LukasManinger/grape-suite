#import "colors.typ" as colors: *
#import "todo.typ": todo, list-todos, hide-todos
#import "elements.typ": *

#import "@preview/hydra:0.5.2": hydra


#let project(
    title: none,
    subtitle: none,

    submit-to: "Submitted to",
    submit-by: "Submitted by",

    university: "UNIVERSITY",
    faculty: "FACULTY",
    institute: "INSTITUTE",
    seminar: "SEMINAR",
    semester: "SEMESTER",
    docent: "DOCENT",

    author: "AUTHOR",
    student-number: none,
    email: "EMAIL",
    address: "ADDRESS",

    title-page-part: none,
    title-page-part-submit-date: none,
    title-page-part-submit-to: none,
    title-page-part-submit-by: none,

    sentence-supplement: "Example",

    date: datetime.today(),
    date-format: (date) => if type(date) == type(datetime.today()) { date.display("[day].[month].[year]") } else { date },

    header: none,
    // header-right: none,
    // header-middle: none,
    // header-left: none,
    show-header-line: true,

    footer: none,
    footer-right: none,
    // footer-middle: none,
    footer-left: none,
    show-footer-line: true,

    show-outline: true,
    show-todolist: true,
    show-declaration-of-independent-work: true,

    page-margins: none,

    text-font: "XCharter",
    math-font: "STIX Two Math",

    fontsize: 11pt,

    title-page: none,
    title-page-page-args: none,
    thesis-statement: none,
    thesis-statement-page-args: none,
    tuda-c: (:),
    width-narrow: 3in,
    width-normal: 5in,
    width-wide: 7in,

    body
) = {
    let ifnn-line(e) = if e != none [#e \ ]

    set text(font: text-font, size: fontsize)
    // show math.equation: set text(font: "Fira Math")
    show math.equation: set text(font: math-font, size: fontsize)  // TODO fontsize?
    show heading: set text(font: "FrontPage Pro")
    show figure.caption: set text(font: "FrontPage Pro", size: 10pt)  // TODO fontsize?
    // show smallcaps: set text(font: "FrontPage Pro Caps")
    show raw: set text(font: "Fira Code", size: 9pt)  // default 8.8

    set enum(indent: 1em)
    set list(indent: 1em)

    // show link: underline
    show link: set text(fill: tuda-c.at("0d"))

    show ref: set text(fill: tuda-c.at("0d"))
    show cite: set text(fill: tuda-c.at("0d"))

    show: format-heading-numbering
    // show: format-quotes // NOTE disabled for now

    show bibliography: set heading(numbering: "1.")
    
    // Adapted from https://github.com/typst/typst/discussions/3871
    // TODO check if linking still works
    show figure.caption: c => context{
        [*#c.supplement #c.counter.display()#c.separator*#c.body]
    }
        //#text(fill: tuda_c.at("10d"))[#c.supplement #c.counter.display(c.numbering)#c.separator]#c.body
    show figure.caption: it => block(width: 100%)[#it]

    // See https://github.com/talal/ilm/blob/main/lib.typ
    // Break large tables across pages.
    // show figure.where(kind: table): set block(breakable: true)
    set table(inset: 6pt, stroke: (0.5pt + tuda-c.at("0c")))

    // show raw.where(block: false): box.with(
    //     fill: tuda_c.at("0a"),
    //     inset: (x: 3pt, y: 0pt),
    //     outset: (y: 3pt),
    //     radius: 2pt,
    // )

    // Block code
    show raw.where(block: true): block.with(
        width: 100%,
        inset: 6pt,
        stroke: 0.5pt + tuda-c.at("0c"),
    )

    set footnote.entry(
        separator: context{
            set align(center)
            line(length: width-normal, stroke: 0.5pt + tuda-c.at("0c"))
        },
        indent: 0em
    )

    // TODO currently kills linking in the PDF
    // See https://forum.typst.app/t/how-can-i-customize-footnote-entry-without-losing-link-functionality/595
    // show footnote.entry: it =>  context {
    //     let num = it.note + [ #sym.zws]
    //     let x-offset = -1 * measure(num).width

    //     pad(left: x-offset, par(hanging-indent: -1 * x-offset, num + it.note.body))
    // }

    // title page
    if title-page != none {
        set page(..title-page-page-args)
        title-page
    } else {
        [
            #set text(size: 1.25em, hyphenate: false)
            #set par(justify: false)

            #v(0.9fr)
            #text(size: 2.5em, fill: purple, strong(title)) \
            #if subtitle != none {
                v(0em)
                text(size: 1.5em, fill: purple.lighten(25%), subtitle)
            }

            #if title-page-part == none [
                #if title-page-part-submit-date == none {
                    ifnn-line(semester)
                    ifnn-line(date-format(date))
                } else {
                    title-page-part-submit-date
                }

                #if title-page-part-submit-to == none {
                    ifnn-line(text(size: 0.6em, upper(strong(submit-to))))
                    ifnn-line(university)
                    ifnn-line(faculty)
                    ifnn-line(institute)
                    ifnn-line(seminar)
                    ifnn-line(docent)
                } else {
                    title-page-part-submit-to
                }

                #if title-page-part-submit-by == none {
                    ifnn-line(text(size: 0.6em, upper(strong(submit-by))))
                    ifnn-line(author + if student-number != none [ (#student-number)])
                    ifnn-line(email)
                    ifnn-line(address)
                } else {
                    title-page-part-submit-by
                }
            ] else {
                title-page-part
            }

            #v(0.1fr)
        ]
    }

    // page setup
    let ufi = ()
    if university != none { ufi.push(university) }
    if faculty != none { ufi.push(faculty) }
    if institute != none { ufi.push(institute) }

    set page(
        margin: if page-margins != none {page-margins} else {
            (top: 2.5cm, bottom: 2.5cm, right: 4cm)
        },
        header: if header != none {header} else {context{
            let c = tuda-c.at("0c")
            set text(size: 8pt, fill: c) // was 0.75em
            set align(center)

            hydra(1, skip-starting: false, use-last: true, display: (ctx, candidate) => candidate.body)
            if show-header-line {
                v(-0.5em)
                line(length: width-wide, stroke: c)
            }
        }}
    )

    state("grape-suite-element-sentence-supplement").update(sentence-supplement)
    show: sentence-logic

    // outline
    if show-outline or show-todolist {
        pad(x: 2em, {
            if show-outline {
                outline(depth: 4, indent: auto)
                v(1fr)
            }

            if show-todolist {
                list-todos()
            }
        })

        pagebreak(weak: true)
    }

    // main body setup
    set page(
        background: context state("grape-suite-seminar-paper-sidenotes", ())
            .final()
            .map(e => context {
                if here().page() == e.loc.at(0) {
                    set par(justify: false, leading: 0.65em)
                    place(top + right, align(left, text(fill: purple, size: 0.75em, hyphenate: false, pad(x: 0.5cm, block(width: 3cm, strong(e.body))))), dy: e.loc.at(1).y)
                } else {
                }
            }).join[],

        footer: if footer != none {footer} else {
            let c = tuda-c.at("0c")
            set text(size: 8pt, fill: c) // was 0.75em
            set align(center)

            if show-footer-line {
                line(length: width-wide, stroke: c)
                v(-0.5em)
            }

            table(columns: (1fr, auto, 1fr),
                align: top,
                stroke: none,
                inset: 0pt,

                if footer-left != none {footer-left},

                align(center, context {
                    str(counter(page).display())
                    [ \/ ]
                    str(counter("grape-suite-last-page").final().first())
                }),

                if footer-right != none {footer-right}
            )
        }
    )
    
    show heading: set text(fill: tuda-c.at("10d"))
    // Put chapter on new page
    show heading.where(level: 1): it => {
        pagebreak()
        it
    }
    // Like LaTeX \paragraph
    // show heading.where(level: 5): it => par(it.body)
    show heading.where(level: 6): it => it.body
    
    set heading(numbering: "1.")
    show heading.where(level: 5).or(heading.where(level: 6)): set heading(numbering: none)

    set par(justify: true)

    counter(page).update(1)
    
    body

    // backup page count, because last page should not be counted
    context counter("grape-suite-last-page").update(counter(page).at(here()))

    // declaration of independent work
    if show-declaration-of-independent-work {
        if thesis-statement != none {
            pagebreak(weak: true)
            set page(..thesis-statement-page-args)
            set heading(outlined: false, numbering: none)

            thesis-statement
        } else {
            pagebreak(weak: true)
            set page(footer: [])

            heading(outlined: false, numbering: none, [Selbstständigkeitserklärung])
            [Hiermit versichere ich, dass ich die vorliegende schriftliche Hausarbeit (Seminararbeit, Belegarbeit) selbstständig verfasst und keine anderen als die von mir angegebenen Quellen und Hilfsmittel benutzt habe. Die Stellen der Arbeit, die anderen Werken wörtlich oder sinngemäß entnommen sind, wurden in jedem Fall unter Angabe der Quellen (einschließlich des World Wide Web und anderer elektronischer Text- und Datensammlungen) kenntlich gemacht. Dies gilt auch für beigegebene Zeichnungen, bildliche Darstellungen, Skizzen und dergleichen. Ich versichere weiter, dass die Arbeit in gleicher oder ähnlicher Fassung noch nicht Bestandteil einer Prüfungsleistung oder einer schriftlichen Hausarbeit (Seminararbeit, Belegarbeit) war. Mir ist bewusst, dass jedes Zuwiderhandeln als Täuschungsversuch zu gelten hat, aufgrund dessen das Seminar oder die Übung als nicht bestanden bewertet und die Anerkennung der Hausarbeit als Leistungsnachweis/Modulprüfung (Scheinvergabe) ausgeschlossen wird. Ich bin mir weiter darüber im Klaren, dass das zuständige Lehrerprüfungsamt/Studienbüro über den Betrugsversuch informiert werden kann und Plagiate rechtlich als Straftatbestand gewertet werden.]

            v(1cm)

            table(columns: (auto, auto, auto, auto),
                stroke: white,
                inset: 0cm,

                strong([Ort:]) + h(0.5cm),
                repeat("."+hide("'")),
                h(0.5cm) + strong([Unterschrift:]) + h(0.5cm),
                repeat("."+hide("'")),
                v(0.75cm) + strong([Datum:]) + h(0.5cm),
                v(0.75cm) + repeat("."+hide("'")),)
        }
    }
}

#let sidenote(body) = context {
    let pos = here()

    state("grape-suite-seminar-paper-sidenotes", ()).update(k => {
        k.push((loc: (pos.page(), pos.position()), body: body))
        return k
    })
}
