#import "colors.typ" as colors: *
#import "todo.typ": todo, list-todos, hide-todos
#import "elements.typ": *

#import "@preview/hydra:0.5.1": hydra
#import "../../my/constants.typ": *
#import "../../tuda-typst-templates/templates/tudapub/tudacolors.typ": tuda_colors, tuda_c
#import "../../tuda-typst-templates/templates/tudapub/common/tudapub_title_page.typ": *


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
    date-format: (date) => date.display("[day].[month].[year]"),

    header: none,
    header-right: none,
    header-middle: none,
    header-left: none,

    footer: none,
    footer-right: none,
    footer-middle: none,
    footer-left: none,

    show-outline: true,
    show-todolist: true,
    show-declaration-of-independent-work: true,

    page-margins: none,
    fontsize: 11pt,

    body
) = {
    let ifnn-line(e) = if e != none [#e \ ]

    set text(font: "Charter", size: fontsize)
    // show math.equation: set text(font: "Fira Math")
    show math.equation: set text(font: "STIX Two Math")
    show heading: set text(font: "FrontPage Pro")
    show figure.caption: set text(font: "FrontPage Pro", size: 10pt)  // TODO fontsize?
    // show smallcaps: set text(font: "FrontPage Pro Caps")

    set par(justify: true)

    set enum(indent: 1em)
    set list(indent: 1em)

    show link: underline
    show link: set text(fill: tuda_c.at("0d"))

    show ref: set text(fill: tuda_c.at("0d"))
    show cite: set text(fill: tuda_c.at("0d"))

    show heading: it => context {
        let num-style = it.numbering

        if num-style == none {
            return it
        }

        let num = text(weight: "light", numbering(num-style, ..counter(heading).at(here()))+[ \u{200b}])
        let x-offset = -1 * measure(num).width

        pad(left: x-offset, par(hanging-indent: -1 * x-offset, text(fill: tuda_c.at("10d"), num) + [] + text(fill: tuda_c.at("10d"), it.body)))
    }

    show figure.caption: it => block(width: 100%)[#it]
    // Adapted from https://github.com/typst/typst/discussions/3871
    // TODO check if linking still works
    show figure.caption: c => [
        *#c.supplement #c.counter.display(c.numbering)#c.separator*#c.body
        //#text(fill: tuda_c.at("10d"))[#c.supplement #c.counter.display(c.numbering)#c.separator]#c.body
    ]

    set footnote.entry(
        separator: context{
            set align(center)
            line(length: width_narrow, stroke: 0.5pt)
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
    // [
    //     #set text(size: 1.25em, hyphenate: false)
    //     #set par(justify: false)

    //     #v(0.9fr)
    //     #text(size: 2.5em, fill: purple, strong(title)) \
    //     #if subtitle != none {
    //         v(0em)
    //         text(size: 1.5em, fill: purple.lighten(25%), subtitle)
    //     }

    //     #if title-page-part == none [
    //         #if title-page-part-submit-date == none {
    //             ifnn-line(semester)
    //             ifnn-line(date-format(date))
    //         } else {
    //             title-page-part-submit-date
    //         }

    //         #if title-page-part-submit-to == none {
    //             ifnn-line(text(size: 0.6em, upper(strong(submit-to))))
    //             ifnn-line(university)
    //             ifnn-line(faculty)
    //             ifnn-line(institute)
    //             ifnn-line(seminar)
    //             ifnn-line(docent)
    //         } else {
    //             title-page-part-submit-to
    //         }

    //         #if title-page-part-submit-by == none {
    //             ifnn-line(text(size: 0.6em, upper(strong(submit-by))))
    //             ifnn-line(author + if student-number != none [ (#student-number)])
    //             ifnn-line(email)
    //             ifnn-line(address)
    //         } else {
    //             title-page-part-submit-by
    //         }
    //      ] else {
    //         title-page-part
    //     }

    //     #v(0.1fr)
    // ]

    tudpub-make-title-page(
        title: [Reverse Engineering 42],
        title_german: [Rückwärtsbauen Zweiundvierzig],
        // "master" or "bachelor" thesis
        thesis_type: "master",
        // the code of the accentcolor.
        // A list of all available accentcolors is in the list tuda_colors
        accentcolor: "10d",
        // language for correct hyphenation
        language: "eng",
        // author name as text, e.g "Albert Author"
        author: "Lukas Maninger",
        // date of submission as string
        date_of_submission: datetime(
            year: 2023,
            month: 10,
            day: 4,
        ),
        location: "Darmstadt",
        // array of the names of the reviewers
        reviewer_names: ("SuperSupervisor 1", "SuperSupervisor 2"),
        // tuda logo, has to be a svg. E.g. image("PATH/TO/LOGO")
        logo_tuda: image("../../../res/tuda_logo_RGB.svg"),
        // optional sub-logo of an institute.
        // E.g. image("logos/iasLogo.jpeg")
        logo_institute: image("../../../res/centre.jpg"),
        // How to set the size of the optional sub-logo.
        // either "width": use tud_logo_width*(2/3)
        // or     "height": use tud_logo_height*(2/3)
        logo_institute_sizeing_type: "width",
        // Move the optional sub-logo horizontally
        logo_institute_offset_right: 0mm,
        // an additional white box with content for e.g. the institute, ... below the tud logo.
        // E.g. logo_sub_content_text: [ Institute A \ filed of study: \ B]
        logo_sub_content_text: none, // [Human Sciences Department \ Institute for Psychology \ Psychology of Information Processing],
        title_height: 3.5em
    )

    // page setup
    let ufi = ()
    if university != none { ufi.push(university) }
    if faculty != none { ufi.push(faculty) }
    if institute != none { ufi.push(institute) }

    set page(
        margin: if page-margins != none {page-margins} else {
            (top: 2.5cm, bottom: 2.5cm, right: 4cm)
        },
        header: context{
            let c = tuda_c.at("0c")
            set text(size: 0.75em, fill: c)
            set align(center)

            hydra(1, skip-starting: false, use-last: true, display: (ctx, candidate) => candidate.body)
            v(-0.5em)
            line(length: width_wide, stroke: c)
        }
    )

    state("grape-suite-element-sentence-supplement").update(sentence-supplement)
    show: sentence-logic

    // outline
    if show-outline or show-todolist {
        pad(x: 2em, {
            if show-outline {
                outline(indent: true)
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
                    place(top + right, align(left, par(justify: false, text(fill: purple, size: 0.75em, hyphenate: false, pad(x: 0.5cm, block(width: 3cm, strong(e.body)))))), dy: e.loc.at(1).y)
                } else {
                }
            }).join[],

        footer: if footer != none {footer} else {
            let c = tuda_c.at("0c")
            set text(size: 0.75em, fill: c)
            set align(center)

            line(length: width_wide, stroke: c)
            v(-0.5em)

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

                if footer-left != none {footer-left}
            )
        }
    )

    set heading(numbering: "1.")
    counter(page).update(1)

    show heading.where(level: 1): it => {
        pagebreak()
        it
    }
    
    body

    // backup page count, because last page should not be counted
    context counter("grape-suite-last-page").update(counter(page).at(here()))

    // declaration of independent work
    if show-declaration-of-independent-work {
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

#let sidenote(body) = context {
    let pos = here()

    state("grape-suite-seminar-paper-sidenotes", ()).update(k => {
        k.push((loc: (pos.page(), pos.position()), body: body))
        return k
    })
}
