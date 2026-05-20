// Yonderland Rock (Crumpit Yonderland) — Squamish Climbing Topo
// Recreated and redesigned with Typst

#set document(
  title: "Yonderland Rock — Climbing Topo",
  author: "Nigel Slater",
)

#set page(
  paper: "us-letter",
  margin: (x: 0.6in, y: 0.55in),
)

#let body-font    = ("Iowan Old Style", "Georgia")
#let display-font = ("Futura", "Helvetica Neue")
#let mono-font    = ("JetBrainsMono NF", "JetBrains Mono", "Menlo")

#set text(
  font: body-font,
  size: 9.5pt,
  fill: rgb("#1c1814"),
)

#set par(justify: false, leading: 0.55em, spacing: 0.55em)
#show grid: set block(above: 0pt)

// --- Color palette ---
#let ink     = rgb("#1c1814")
#let muted   = rgb("#6a6359")
#let divider = rgb("#d7cdba")
#let paper   = rgb("#f1ebde")
#let accent  = rgb("#2f4326")
#let stone   = rgb("#3a3530")
#let rust    = rgb("#8a3a1c")

// --- Grade coloring (shared with paradise-alley) ---
#let grade-position(g) = {
  let s = lower(g).replace(" ", "")
  if s.starts-with("5.6") { 1 }
  else if s.starts-with("5.7") { 2 }
  else if s.starts-with("5.8") { 3 }
  else if s.starts-with("5.9") { 4 }
  else {
    let base = if s.starts-with("5.10") { 5 }
      else if s.starts-with("5.11") { 9 }
      else if s.starts-with("5.12") { 13 }
      else if s.starts-with("5.13") { 17 }
      else { 0 }
    let letter-offset = if s.ends-with("a") or not (s.ends-with("b") or s.ends-with("c") or s.ends-with("d")) { 0 }
      else if s.ends-with("b") { 1 }
      else if s.ends-with("c") { 2 }
      else { 3 }
    base + letter-offset
  }
}

#let grade-stops = (
  (0,  rgb("#9ad8b6")),
  (5,  rgb("#3e9270")),
  (9,  rgb("#4f93d3")),
  (13, rgb("#9985d4")),
  (17, rgb("#3d3582")),
)

#let grade-color(g) = {
  let s = lower(g)
  if s.contains("–") or s.contains("-") and s.starts-with("5.") {
    return rgb("#4ca783")
  }
  let pos = grade-position(g)
  if pos <= grade-stops.at(0).at(0) { return grade-stops.at(0).at(1) }
  if pos >= grade-stops.last().at(0) { return grade-stops.last().at(1) }
  let i = 0
  while i < grade-stops.len() - 1 and pos >= grade-stops.at(i + 1).at(0) {
    i = i + 1
  }
  let (p1, c1) = grade-stops.at(i)
  let (p2, c2) = grade-stops.at(i + 1)
  let t = (pos - p1) / (p2 - p1)
  color.mix((c1, (1.0 - t) * 100%), (c2, t * 100%), space: oklch)
}

// --- Components ---

#let grade-pill(g) = box(
  fill: grade-color(g),
  inset: (x: 5pt, y: 2pt),
  radius: 2pt,
  baseline: 1.5pt,
  text(font: mono-font, fill: white, weight: 700, size: 7.5pt, g),
)

#let route-num(n, color: ink) = box(
  width: 16pt, height: 16pt,
  fill: color,
  radius: 50%,
  inset: 0pt,
  align(center + horizon, text(font: mono-font, fill: white, weight: 700, size: 8pt, str(n))),
)

#let route(num, name, grade, desc, fa, bolts: none) = block(
  breakable: false,
  below: 9pt,
  grid(
    columns: (18pt, 1fr),
    column-gutter: 7pt,
    route-num(num),
    pad(top: 1pt)[
      #text(font: display-font, weight: 600, size: 9.5pt, fill: ink, name) #h(4pt) #grade-pill(grade)
      #v(-3pt)
      #text(size: 8.8pt, fill: stone, desc) \
      #text(size: 7.5pt, fill: muted, style: "italic", {
        if bolts != none [#str(bolts) bolts #sym.bullet ]
        fa
      })
    ]
  ),
)

#let project-route(num, name, fa, open: false) = block(
  breakable: false,
  below: 9pt,
  grid(
    columns: (18pt, 1fr),
    column-gutter: 7pt,
    route-num(num, color: muted),
    [
      #text(font: display-font, weight: 600, size: 9.5pt, fill: ink, name) #h(4pt) #box(fill: muted, inset: (x: 5pt, y: 2pt), radius: 2pt, text(font: mono-font, fill: white, weight: 700, size: 7.5pt, if open { "OPEN PROJECT" } else { "CLOSED PROJECT" })) \
      #text(size: 7.5pt, fill: muted, style: "italic", fa)
    ]
  ),
)

#let wall-header(name, subtitle: none) = block(
  below: 8pt,
  above: 0pt,
  [
    #text(font: display-font, weight: 500, size: 26pt, fill: stone, name)
    #if subtitle != none [
      #v(2pt)
      #text(size: 9pt, fill: muted, style: "italic", subtitle)
    ]
    #v(4pt)
    #line(length: 100%, stroke: 0.5pt + divider)
  ],
)

#let section-label(s) = text(
  font: mono-font,
  size: 7.5pt,
  weight: 700,
  fill: accent,
  tracking: 1pt,
  upper(s),
)

#let stat-block(label, value) = block(
  inset: (x: 8pt, y: 6pt),
  radius: 3pt,
  stroke: 0.5pt + divider,
  [
    #section-label(label) \
    #v(-3pt)
    #text(weight: 600, size: 10pt, value)
  ],
)

// =====================================================
// ROUTE DATA
// =====================================================
// The whole crag as data. Each wall is rendered in order; the cover page's
// grade distribution and stats are derived from this list — no hand-counting.

#let walls = (
  (
    name: "Far Left",
    subtitle: "Three routes on the leftmost bulge — a short warm-up and two cruxy lines.",
    image: "images/walls/sector1.jpg",
    image-height: 3.6in,
    routes: (
      (num: 1, name: "A sigh of resentment", grade: "5.9", bolts: 4,
        desc: "Climb through the bulge at the left edge of the crag. A short warm-up.",
        fa: "Nigel Slater & Robin Barley, 5 April 2025"),
      (num: 2, name: "Half a Dream", grade: "5.12b",
        desc: "Direct through the bulge on crimps. A 7-move wonder. Dream or nightmare? Fixed gear but bring a quickdraw for the top.",
        fa: "Nigel Slater & Robin Barley, 14 June 2025"),
      (num: 3, name: "Ok Deary", grade: "5.11c",
        desc: "Above the fire, roof, shallow corner, then left up the ramp. Fixed gear in the lower section — bring two quickdraws for the upper wall. Fun climbing and heel hooking.",
        fa: "Nigel Slater & Robin Barley, 5 April 2025"),
    ),
  ),
  (
    name: "Left & Center",
    subtitle: "The main spread — seven routes from the open groove across the central face.",
    image: "images/walls/sector2.jpg",
    image-height: 3.4in,
    routes: (
      (num: 4, name: "Grizelda's Flake", grade: "5.10a",
        desc: "Start below the big open groove. Boulder through the bulge, then climb the flake in the left wall.",
        fa: "Hugh Dickens, 11 August 2024"),
      (num: 5, name: "Robby's Runnel", grade: "5.10a",
        desc: "Same start as #4, but continue up the open groove with interest.",
        fa: "Nigel Slater & Robin Barley, 13 July 2024"),
      (num: 6, name: "Old Cronies", grade: "5.11a", bolts: 11,
        desc: "Tricky start through the bulge, then ascend the wall, arete, and airy headwall and final slab. Go past the white anchor rings on route #8.",
        fa: "Nigel Slater & Robin Barley, 20 July 2024"),
      (num: 7, name: "Fudge Finder", grade: "5.11a", bolts: 9,
        desc: "Direct to the bulge, then move right up steep ground to finish over the lip.",
        fa: "Nigel Slater & Robin Barley, 27 July 2024"),
      (num: 8, name: "For Octogenarians", grade: "5.7",
        desc: "Connector from route #7 to rappel rings on #6 (white bolt and anchor rings).",
        fa: "Robin Barley, 5 May 2025"),
      (num: 9, name: "Brassed Off", grade: "5.11c", bolts: 10,
        desc: "Yellow/green bolts. Start off the block, then direct with hard moves through the bulge.",
        fa: "Nigel Slater & Robin Barley, 26 November 2024"),
      (num: 10, name: "The Good, the Bad and the Sloper", grade: "5.11c", bolts: 11,
        desc: "Tricky start, then direct up the wall to tough moves through the left side of the diamond-shaped roof.",
        fa: "Nigel Slater & Robin Barley, 4 August 2024"),
    ),
  ),
  (
    name: "Middle",
    subtitle: "Crimpy walls into the big semi-circular roof — pick your line under the lip.",
    image: "images/walls/sector3.jpg",
    image-height: 3.6in,
    routes: (
      (num: 11, name: "Shadoodled", grade: "5.10c", bolts: 5,
        desc: "Short crimpy climb to finish under the diamond-shaped roof. Starts in the shallow corner.",
        fa: "Nigel Slater & Robin Barley, 27 July 2024"),
      (num: 12, name: "Queen of the sofa", grade: "5.10c",
        desc: "Starts at the left end of the rope traverse. Wall to hanging groove, then step right and finish up the crack under the left end of the big semi-circular roof.",
        fa: "Nigel Slater & Robin Barley, 13 July 2024"),
      (num: 13, name: "The Floater", grade: "5.11c",
        desc: "Start on the block midway along the rope traverse. Anchor your belayer. Perplexing moves over the lower bulge (\"beached-whale style\"), then direct up the wall to the sapling under the big roof.",
        fa: "Nigel Slater & Robin Barley, 13 July 2024"),
      (num: 14, name: "Big Roof project", project: true, open: false,
        fa: "In progress — closed."),
      (num: 15, name: "Bloatamax 3000+ pro", grade: "5.11a", bolts: 13,
        desc: "Start at the right end of the rope traverse. Anchor your belayer. Directly up the wall, then over the right end of the big semi-circular roof, and up the slab to finish.",
        fa: "Nigel Slater & Robin Barley, 1 September 2024"),
    ),
  ),
  (
    name: "Right",
    subtitle: "Two routes squeezed under the big roof's right side.",
    image: "images/walls/sector4.jpg",
    image-height: 3.4in,
    routes: (
      (num: 16, name: "Hog Patrol", grade: "5.11a",
        desc: "Move right from the second bolt on route #15, then directly up the wall to a separate lower-off.",
        fa: "Nigel Slater & Robin Barley, 15 September 2024"),
      (num: 17, name: "The Honey-do List", grade: "5.12a",
        desc: "Bouldery cave roof, then right into the corner, back left over the second roof, to an easier finish. Start off the sloping shelf at the left side of the yellow alcove. Something to tick from the list…",
        fa: "Nigel Slater & Robin Barley, 13 July 2024"),
    ),
  ),
  (
    name: "Far Right",
    subtitle: "The crag's right-hand end — slabby starts into steep boulder problems.",
    image: "images/walls/sector5.jpg",
    image-height: 3.2in,
    routes: (
      (num: 18, name: "Off the clock", grade: "5.10d",
        desc: "Roof and wall right of the yellow alcove, starting off the large boulder. A little ledgy, but has some fun moves.",
        fa: "Nigel Slater & Robin Barley, 26 April 2025"),
      (num: 19, name: "Fatberg", grade: "5.10c",
        desc: "Start 2 m right. A steep start, then exit through the left side of the diagonal roof. Named for the 130-tonne, 250-metre London fatberg that blocked a section of Victorian-era sewers for over two months.",
        fa: "Nigel Slater & Robin Barley, 26 April 2025"),
      (num: 20, name: "Water Story", grade: "5.11c", bolts: 6,
        desc: "Last route at the far-right end. Slabby start followed by a steep boulder problem to the black headwall.",
        fa: "Nigel Slater & Robin Barley, 10 May 2025"),
    ),
  ),
)

// All routes, flattened across walls. Used to derive counts + chart data.
#let all-routes = walls.map(w => w.routes).flatten()
#let sport-routes = all-routes.filter(r => not r.at("project", default: false))
#let project-count = all-routes.len() - sport-routes.len()

// Grade -> count, ordered by grade-position (so the chart goes easy → hard).
#let grade-counts = {
  let acc = (:)
  for r in sport-routes {
    acc.insert(r.grade, acc.at(r.grade, default: 0) + 1)
  }
  acc.pairs().sorted(key: ((g, _)) => grade-position(g))
}
#let max-grade-count = calc.max(..grade-counts.map(((_, n)) => n))

// Render one route — dispatches to project-route for closed/open projects.
#let render-route(r) = if r.at("project", default: false) {
  project-route(r.num, r.name, r.fa, open: r.at("open", default: false))
} else {
  route(r.num, r.name, r.grade, r.desc, r.fa, bolts: r.at("bolts", default: none))
}

// Split routes into two columns: first half left, rest right.
#let two-col-routes(rs) = {
  let half = calc.ceil(rs.len() / 2)
  grid(
    columns: (1fr, 1fr),
    column-gutter: 18pt,
    align: top,
    rs.slice(0, half).map(render-route).join(),
    rs.slice(half).map(render-route).join(),
  )
}

// =====================================================
// COVER PAGE
// =====================================================

#page(
  margin: 0pt,
  background: rect(fill: paper, width: 100%, height: 100%),
)[
  #v(0.9in)
  #align(center)[
    #text(font: mono-font, size: 8pt, fill: accent, weight: 700, tracking: 3pt, "SQUAMISH · BRITISH COLUMBIA")
    #v(0.3in)
    #text(font: display-font, size: 64pt, weight: 500, fill: stone, tracking: -2pt, "Yonderland")
    #v(-22pt)
    #text(font: display-font, size: 64pt, weight: 700, fill: accent, tracking: 2pt, upper("Rock"))
    #v(0.15in)
    #block(width: 4in, stroke: (top: 0.7pt + ink, bottom: 0.7pt + ink), inset: (y: 8pt))[
      #text(font: mono-font, size: 9pt, fill: stone, tracking: 2pt, "A SPORT CLIMBING TOPO")
    ]
    #v(0.25in)
    #text(size: 11pt, fill: muted, style: "italic", str(sport-routes.len()) + " routes · up to 20 m · West-facing sport climbing")
  ]

  #v(0.25in)
  #align(center)[
    #box(width: 5.5in)[
      #grid(
        columns: (1fr, 1fr, 1fr),
        column-gutter: 12pt,
        stat-block("Total Routes", str(sport-routes.len()) + " sport + " + str(project-count) + " project"),
        stat-block("Route Length", "up to 20 m"),
        stat-block("Approach", "1.4 km · 20–25 min"),
      )
    ]
  ]

  #v(0.45in)
  #align(center)[
    #box(width: 6.5in)[
      #align(left)[
        #section-label("Grade Distribution")
        #v(2pt)
        #line(length: 100%, stroke: 0.5pt + divider)
        #v(14pt)
        #let chart-h = 80pt
        #grid(
          columns: grade-counts.len() * (1fr,),
          column-gutter: 5pt,
          align: bottom + center,
          ..grade-counts.map(((g, n)) => align(bottom + center, stack(
            dir: ttb,
            spacing: 3pt,
            text(font: mono-font, size: 7.5pt, fill: stone, weight: 700, str(n)),
            rect(
              width: 75%,
              height: chart-h * n / max-grade-count,
              fill: grade-color(g),
              radius: (top: 3pt),
              stroke: none,
            ),
          )))
        )
        #v(3pt)
        #grid(
          columns: grade-counts.len() * (1fr,),
          column-gutter: 5pt,
          align: top + center,
          ..grade-counts.map(((g, _)) => text(font: mono-font, size: 7.5pt, fill: muted, g))
        )
      ]
    ]
  ]

  #place(bottom + center, dy: -0.5in)[
    #align(center)[
      #text(font: mono-font, size: 7.5pt, fill: muted, tracking: 1.5pt, upper("Developed by Nigel Slater & Robin Barley"))
    ]
  ]
]

// =====================================================
// APPROACH & OVERVIEW
// =====================================================

#block(
  below: 8pt,
  above: 0pt,
  [
    #text(font: display-font, weight: 500, size: 26pt, fill: stone, "Approach & Overview")
    #v(2pt)
    #text(size: 9pt, fill: muted, style: "italic", "Getting there, what to expect, and other-user etiquette.")
    #v(4pt)
    #line(length: 100%, stroke: 0.5pt + divider)
  ],
)

#block(below: 10pt)[
  Developed in 2024/25 by Nigel Slater and Robin Barley, this west-facing sport crag features 19 well-bolted routes reaching up to 20 m high. Characterised by bulges, overhangs, and technical crimping, it offers a solid selection of climbs in the 5.10 to 5.11 range, with a couple of 12s. Huge thanks to David C., Leon R., and Christopher C. for generously donating ropes toward the development of this crag.
]

#grid(
  columns: (1.4fr, 1fr),
  column-gutter: 16pt,
  row-gutter: 12pt,
  // ---- Row 1: Parking ↔ Cover photo ----
  [
    #section-label("Parking")
    #v(2pt)
    Approach as for Fern Hill — from the large parking lot at the end of the Powerhouse Springs forest service road. There are ongoing construction activities with the Pipeline and Squamish Canyon project, so follow the *"Visitor Parking"* signs.

    #v(10pt)
    #block(
      fill: paper,
      stroke: (left: 2pt + rust),
      inset: 8pt,
      radius: 0pt,
    )[
      #text(font: mono-font, size: 7.5pt, weight: 700, fill: rust, tracking: 1pt, "NOTE") \
      #v(2pt)
      Not a brilliant place for small children — knotted ropes are needed to access the ledge below the climbs, and some friable rock remains. *Helmets strongly recommended.*
    ]

    #v(4pt)
    Located roughly 10 minutes "around the corner" from Fern Hill. About 10 minutes by bike from the lot.

    #v(4pt)
    #text(font: mono-font, size: 7.5pt, fill: muted, tracking: 0.5pt, "GPS · 49°43'24\"N 123°06'19\"W")
  ],
  align(center)[
    #image("images/climber.jpg", height: 3.1in)
    #v(2pt)
    #text(size: 7.5pt, fill: muted, style: "italic", "Looking out from the crag toward the Tantalus range.")
  ],
  // ---- Row 2: Approach text ↔ Approach photo strip ----
  [
    #section-label("Approach (1.4 km · 20–25 min)")
    #v(2pt)
    From the north end of the lot (toilet block) walk through the concrete blocks and along the trail for 200 m, then take the *"Far side"* trail left into the forest. After 900 m and ten switchbacks, keep right on Far side trail at the wooden signpost for *5 Point Hill* (photo 1).

    #v(3pt)
    Far side trail contours west around the hillside. Keep left at the fork to 5 Point Hill (photo 2), then 20 m past the sign go straight into the forest (photo 3), up the slope (fixed rope), and the crag appears on the left.
  ],
  align(center)[
    #image("images/approach.jpg", width: 100%)
    #v(2pt)
    #text(size: 7.5pt, fill: muted, style: "italic", "Approach waypoints 1 → 3.")
  ],
)

#v(1fr)

#section-label("Crag Notes")
#v(4pt)
#line(length: 100%, stroke: 0.5pt + divider)
#v(4pt)

#grid(
  columns: (1fr, 1fr, 1fr, 1fr),
  column-gutter: 14pt,
  [*West-facing.* Morning shade until ~2 pm, then full sun. A steady afternoon breeze keeps it pleasant.],
  [*Mosquitoes.* Noticeably fewer than nearby crags — one of the more livable Squamish summer venues.],
  [*Gear.* 10–14 quickdraws suffices for most routes. All routes equipped with lower-offs.],
  [*Top-rope etiquette.* Use your own quickdraws on the anchors to reduce wear on the fixed gear.],
)

// =====================================================
// WALL PAGES — rendered from the `walls` data above
// =====================================================

#for (i, wall) in walls.enumerate() [
  #pagebreak()
  #wall-header(wall.name, subtitle: wall.subtitle)
  #align(center, image(wall.image, height: wall.image-height))
  #v(8pt)
  #two-col-routes(wall.routes)
]

#v(1fr)

#align(center)[
  #line(length: 3in, stroke: 0.5pt + divider)
  #v(8pt)
  #text(size: 8pt, fill: muted, tracking: 2pt, upper("End of guide · climb safe · pack it out"))
  #v(10pt)
  #text(font: mono-font, size: 6.5pt, fill: muted, tracking: 1pt, "Topo by @zaymonoid")
]
