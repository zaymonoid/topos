// Paradise Alley — Squamish Climbing Topo
// Recreated and redesigned with Typst

#set document(
  title: "Paradise Alley — Climbing Topo",
  author: "Alex Ryan Tucker",
)

#set page(
  paper: "us-letter",
  margin: (x: 0.6in, y: 0.55in),
)

// Body: New York (refined editorial serif)
// Display: Futura (geometric — Sierra Club / NPS poster lineage)
// Badges/labels: JetBrains Mono (technical, guidebook-rack feel)
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

// --- Color palette (warm earth, guidebook lineage) ---
#let ink     = rgb("#1c1814")   // warm near-black, ink on paper
#let muted   = rgb("#6a6359")   // warm grey
#let divider = rgb("#d7cdba")   // tea-stained rule
#let paper   = rgb("#f1ebde")   // warm parchment, not "AI cream"
#let accent  = rgb("#2f4326")   // deep moss / lichen green
#let stone   = rgb("#3a3530")   // warm graphite
#let rust    = rgb("#8a3a1c")   // oxide red, used sparingly for warnings

// Grade pills: one tonal ramp through warm earth tones (no rainbow)
#let grade-color(g) = {
  let s = lower(g)
  if s.starts-with("5.6") or s.starts-with("5.7") or s.starts-with("5.8") or s.starts-with("5.9") {
    rgb("#5a7148")    // sage — easy
  } else if s.starts-with("5.10") {
    rgb("#2f5a78")    // denim blue — moderate
  } else if s.starts-with("5.11") {
    rgb("#8a4a26")    // umber — hard
  } else if s.starts-with("5.12") {
    rgb("#6e2a1f")    // oxblood — expert
  } else if s.starts-with("5.13") {
    rgb("#3a2638")    // aubergine — elite
  } else {
    rgb("#6a6359")
  }
}

// --- Components ---

#let grade-pill(g) = box(
  fill: grade-color(g),
  inset: (x: 5pt, y: 2pt),
  radius: 2pt,
  text(font: mono-font, fill: white, weight: 700, size: 7.5pt, g),
)

#let route-num(n, color: ink) = box(
  width: 16pt, height: 16pt,
  fill: color,
  radius: 50%,
  inset: 0pt,
  align(center + horizon, text(font: mono-font, fill: white, weight: 700, size: 8pt, str(n))),
)

#let route(num, name, grade, desc, fa) = block(
  breakable: false,
  below: 5pt,
  grid(
    columns: (18pt, 1fr),
    column-gutter: 7pt,
    route-num(num),
    [
      #text(font: display-font, weight: 600, size: 9.5pt, fill: ink, name) #h(4pt) #grade-pill(grade) \
      #text(size: 8.8pt, fill: stone, desc) \
      #text(size: 7.5pt, fill: muted, style: "italic", fa)
    ]
  ),
)

#let project-route(num, name, fa, open: false) = block(
  breakable: false,
  below: 5pt,
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

#let wall-header(num, name, subtitle: none) = block(
  below: 8pt,
  above: 0pt,
  [
    #grid(
      columns: (auto, 1fr),
      column-gutter: 12pt,
      align: horizon,
      box(
        fill: accent,
        inset: (x: 10pt, y: 6pt),
        radius: 2pt,
        text(font: mono-font, fill: white, weight: 700, size: 11pt, tracking: 1pt, "WALL " + str(num)),
      ),
      text(font: display-font, weight: 500, size: 22pt, fill: stone, name),
    )
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
    #text(font: display-font, size: 64pt, weight: 500, fill: stone, tracking: -2pt, "Paradise")
    #v(-22pt)
    #text(font: display-font, size: 64pt, weight: 700, fill: accent, tracking: 2pt, upper("Alley"))
    #v(0.15in)
    #block(width: 4in, stroke: (top: 0.7pt + ink, bottom: 0.7pt + ink), inset: (y: 8pt))[
      #text(font: mono-font, size: 9pt, fill: stone, tracking: 2pt, "A SPORT CLIMBING TOPO")
    ]
    #v(0.25in)
    #text(size: 11pt, fill: muted, style: "italic", "46 routes · 8–20 m · Bolted sport climbing on granite")
  ]

  #v(0.25in)
  #align(center)[
    #box(width: 5.5in)[
      #grid(
        columns: (1fr, 1fr, 1fr),
        column-gutter: 12pt,
        stat-block("Total Routes", "46 sport routes"),
        stat-block("Route Length", "8 – 20 m"),
        stat-block("Approach", "1.3 km · 80 m gain · 20 min"),
      )
    ]
  ]

  #v(0.5in)
  #align(center)[
    #box(width: 5.5in)[
      #align(left)[
        #section-label("Grade Distribution")
        #v(2pt)
        #line(length: 100%, stroke: 0.5pt + divider)
        #v(6pt)
        #grid(
          columns: (1fr, 1fr, 1fr, 1fr, 1fr),
          column-gutter: 8pt,
          align: center,
          [#grade-pill("5.6–5.9") \ #text(size: 8pt, fill: muted, "Beginner")],
          [#grade-pill("5.10") \ #text(size: 8pt, fill: muted, "Moderate")],
          [#grade-pill("5.11") \ #text(size: 8pt, fill: muted, "Hard")],
          [#grade-pill("5.12") \ #text(size: 8pt, fill: muted, "Expert")],
          [#grade-pill("5.13") \ #text(size: 8pt, fill: muted, "Elite")],
        )
      ]
    ]
  ]

  #place(bottom + center, dy: -0.5in)[
    #align(center)[
      #text(font: mono-font, size: 7.5pt, fill: muted, tracking: 1.5pt, upper("Compiled by Alex Ryan Tucker")) \
      #v(2pt)
      #text(font: mono-font, size: 6pt, fill: muted, tracking: 1pt, upper("Reformatted by Zaymon Antonio"))
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

#grid(
  columns: (1.4fr, 1fr),
  column-gutter: 16pt,
  row-gutter: 12pt,
  // ---- Row 1: Parking ↔ Crag overview ----
  [
    #section-label("Parking")
    #v(2pt)
    Drive north from Squamish on Highway 99. Shortly before reaching Chek Canyon, you cross the Big Orange Bridge over Culliton Creek. The parking is 1.5 km after this bridge — a large gravel pullout on the left side.

    #v(4pt)
    #block(
      fill: paper,
      stroke: (left: 2pt + rust),
      inset: 8pt,
      radius: 0pt,
    )[
      #text(font: mono-font, size: 7.5pt, weight: 700, fill: rust, tracking: 1pt, "CAUTION") \
      #v(2pt)
      *Do not turn directly into it across the highway* — an accident could result in the parking being shut down. Instead, drive up to the salt sheds just north of Chek, turn around there, and drive back south. It comes up quick — slow down early.
    ]

    #v(4pt)
    You can also get there by bike via the Sea to Sky trail. 25 minutes from downtown Squamish by car.

    #v(4pt)
    #link("https://osm.org/go/WJR9myVox--?m=")[
      #box(
        fill: paper,
        stroke: 0.5pt + accent,
        inset: (x: 8pt, y: 5pt),
        radius: 3pt,
      )[
        #text(font: mono-font, size: 8.5pt, weight: 700, fill: accent, tracking: 0.5pt, "→ PIN FOR PARKING")
      ]
    ]
  ],
  align(center)[
    #image("paradise-alley-images/overview.jpg", height: 2.6in)
    #v(2pt)
    #text(size: 7.5pt, fill: muted, style: "italic", "Crag overview — wall numbers")
  ],
  // ---- Row 2: Approach ↔ Aerial approach ----
  [
    #section-label("Approach (1.3 km · 80 m elevation)")
    #v(2pt)
    Head past the yellow gate and follow the logging road with powerlines along it. After 10–15 minutes you will see another logging road heading uphill to the left, across a small ditch — the powerline splits off this way. Follow it to the crag. *20 minutes.*
  ],
  align(center)[
    #image("paradise-alley-images/img-000.jpg", width: 100%)
    #v(2pt)
    #text(size: 7.5pt, fill: muted, style: "italic", "Aerial view — orange line shows the approach.")
  ],
)

#v(10pt)
#section-label("Other Information")
#v(4pt)
#line(length: 100%, stroke: 0.5pt + divider)
#v(4pt)

#grid(
  columns: (1fr, 1fr, 1fr, 1fr),
  column-gutter: 14pt,
  [*Loose rock.* Like all new areas, loose rock is a hazard and some climbs may be a little dusty.],
  [*Shared trails.* The area is used by other recreationalists including trials bikers, hunters, and hikers — please be respectful of them.],
  [*Ticks.* Like Cat Lake and Area 44, ticks are common — especially in the spring.],
  [*Top-rope access.* Easiest for Wall 5. Scramble up the loose gully on the right or walk around the left. Use trees to access the edge safely.],
)

#pagebreak()

// =====================================================
// WALL 1 — Operation Fiscal  (routes 1-4)
// =====================================================

#wall-header(1, "Operation Fiscal", subtitle: "Four routes on the prominent face left of the corner system.")

#grid(
  columns: (auto, 1fr),
  column-gutter: 16pt,
  align: top,
  image("paradise-alley-images/walls/wall1.jpg", height: 3.2in),
  [
    #route(1, "Operation Fiscal Jackhammer", "5.12c",
      "Combine intricate technique, brute force, and a brave spirit to defeat this climb.",
      "Liam Church, 2025")

    #route(2, "Kickstart Some Crime", "5.10a",
      "Thin face climbing up the slab.",
      "Liam Church, 2024")

    #project-route(3, "Open Project", "Prep: Liam Church", open: true)

    #route(4, "Señor Leñador", "5.12a",
      "Short and punchy. Climb the aesthetic corner and attempt to decipher its bouldery crux.",
      "Liam Church, 2024")
  ],
)

#v(14pt)

// =====================================================
// WALL 2 — Hammer Time  (route 5)
// =====================================================

#wall-header(2, "Hammer Time", subtitle: "A single standout line on smooth stone.")

#grid(
  columns: (auto, 1fr),
  column-gutter: 16pt,
  align: top,
  image("paradise-alley-images/walls/wall2.jpg", height: 2.8in),
  [
    #route(5, "Hammer Time", "5.11c",
      "A trickier-than-expected bottom section leads into powerful moves on smooth stone with a satisfying finish.",
      "Peter Suke, 2025")
  ],
)

#pagebreak()

// =====================================================
// WALL 3 — Magic Bullet  (routes 6-12)
// =====================================================

#wall-header(3, "Magic Bullet", subtitle: "The biggest concentration of moderates — seven routes packed together.")

#grid(
  columns: (1.6fr, 1fr),
  column-gutter: 16pt,
  align: top,
  image("paradise-alley-images/walls/wall3.jpg", width: 100%),
  [
    #route(6, "The Matter Baby", "5.12a",
      "Tricky over the bulge to great face climbing on small edges.",
      "Rick Willison, 2023")

    #route(7, "Magic Bullet", "5.11c",
      "Maybe the best route here? Get on it.",
      "Rick Willison, 2023")

    #route(8, "Algorithm Schism", "5.10d",
      "The corner leads to a tough crux to finish.",
      "Rick Willison, 2023")

    #route(9, "Rubber Bandit", "5.8",
      "Some fun climbing around bulges.",
      "Rick Willison, 2023")

    #route(10, "Neural Garden", "5.9",
      "Fun, easy climbing.",
      "Rick Willison, 2023")

    #route(11, "Crimpanzee", "5.11b",
      "Easy climbing to a deceptively hard crux.",
      "Rick Willison, 2023")

    #route(12, "Safety in Numbers", "5.12a",
      "Tricky climbing most of the way. Lots of bolts — maybe too many!",
      "Rick Willison, 2023")
  ],
)

#v(10pt)

// =====================================================
// WALL 4 — Layer Cake  (routes 13-15)
// =====================================================

#wall-header(4, "Layer Cake", subtitle: "Three lines on a steep block — a mix of slab and crimp.")

#grid(
  columns: (auto, 1fr),
  column-gutter: 16pt,
  align: top,
  image("paradise-alley-images/walls/wall4.jpg", height: 2.4in),
  [
    #route(13, "Layer Cake", "5.11c",
      "Hard move off the ground and a tricky first half. The slabby second half is *chef's kiss*!",
      "Rick Willison, 2023")

    #route(14, "The Gunslinger", "5.12c",
      "Hard, thin climbing at the start leads to easier climbing and a nice crack feature. Not bad.",
      "Rick Willison, 2023")

    #route(15, "Sucker for Punishment", "5.12b",
      "Maybe the worst climb here? Pretty good climbing higher up is marred by a terrible start on bad rock. You've been warned.",
      "Rick Willison, 2023")
  ],
)

#pagebreak()

// =====================================================
// WALL 5 — Spoonerisms  (routes 16-29)  — the big wall
// =====================================================

#wall-header(5, "Spoonerisms", subtitle: "The crag's centerpiece — fourteen routes from beginner jugs to hard 5.11.")

#align(center, image("paradise-alley-images/walls/wall5.jpg", height: 3.6in))

#v(8pt)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 18pt,
  [
    #project-route(16, "Bodhi Boy", "Art Bass")

    #project-route(17, "In progress — closed!", "Art Bass")

    #route(18, "No Country for Bold Men", "5.10a",
      "Work up the face on small holds and thin seams to reach the easier top half.",
      "Alex Ryan Tucker, 2023")

    #route(19, "Feeble Knievel", "5.7",
      "Follow the left-leaning crack, taking advantage of the generous hand and footholds all around it.",
      "Georgia Dow, 2024")

    #route(20, "Peeling Fumped", "5.9",
      "Trend up and left to a thin finish where the holds shrink away from you.",
      "Alex Ryan Tucker, 2023")

    #route(21, "Spoonerisms", "5.8",
      "Follow good holds through the bottom section then move right at a crux to reach an easy finish.",
      "Nicky Price, 2023")

    #route(22, "Rubber Dinghy Rapids", "5.6",
      "Flow up the rippling jugs. A great beginner route.",
      "Alex Ryan Tucker, 2023")
  ],
  [
    #route(23, "Figure Eighted and Elated", "5.9",
      "Good face climbing on some interesting holds.",
      "Paola Ferrari, 2024")

    #route(24, "Less Talking More Chalking", "5.8",
      "Start up the wide crack on good but sometimes hidden holds, then break up the face to finish.",
      "Alex Ryan Tucker, 2025")

    #route(25, "Drunken Sailor", "5.11c",
      "A burly lower section and crimpy, balancy crux make for a nice contrast on this route.",
      "Liam Church, 2024")

    #route(26, "It's A Trap", "5.11c",
      "The difficulties are shortlived but real on this one, but close bolting makes it approachable.",
      "Prep Willow Rigsby/Alex RT, FA Alex, 2025")

    #route(27, "Not So Neato Mosquito", "5.11a",
      "Resist the barn door on the lower section, then get ready for a tricky slab finish.",
      "Pao Ferrari, 2024")

    #route(28, "PO", "5.10d",
      "Climb up to a burly crux through the small roof. There are many ways to tackle it.",
      "Willow Rigsby, 2024")

    #route(29, "Under the Wire", "5.11b",
      "The overlap offers a slopey crux, which is significantly harder than the rest of the route.",
      "Alex Ryan Tucker, 2023")
  ],
)

#pagebreak()

// =====================================================
// WALL 6 — Birds of Paradise  (routes 30-37)
// =====================================================

#wall-header(6, "Birds of Paradise", subtitle: "The marquee wall — features the area's hardest line.")

#align(center, image("paradise-alley-images/walls/wall6.jpg", height: 4in))

#v(8pt)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 18pt,
  [
    #route(30, "Squishy Boots", "5.8",
      "Small but positive holds up the ramp. Fun!",
      "Rick Willison, 2023")

    #route(31, "Electric Souper Man", "5.11a",
      "A physical start then move left onto the face. Some may say contrived — they'd be right.",
      "Rick Willison, 2023")

    #route(32, "The Nightmare of Milky Joe", "5.11b",
      "Follow good holds up the crack. Clip a bolt out left, then traverse to a jug near the arete.",
      "Rick Willison, 2023")

    #route(33, "The Downstairs Mixup", "5.11c",
      "Excellent holds and great movement up the face. Great.",
      "Rick Willison, 2023")
  ],
  [
    #project-route(34, "Project", "Rick Willison")

    #route(35, "Birds of Paradise", "5.13a",
      "Thin, delicate climbing on small holds to a big move from the slot and an easier finish. Very good.",
      "Rick Willison, 2025")

    #route(36, "Threat Level Midnight", "5.12a",
      "Another great route on really nice rock.",
      "Rick Willison, 2024")

    #route(37, "Shabooya Roll Call", "5.12b",
      "It may be harder. Shares some holds with TLM.",
      "Rick Willison, 2024")
  ],
)

#pagebreak()

// =====================================================
// WALL 7 — View from the Top  (routes 38-46)
// =====================================================

#wall-header(7, "View from the Top", subtitle: "Steep, harder climbing — the wall's last routes wrap around the corner.")

#align(center, image("paradise-alley-images/walls/wall7.jpg", height: 3.8in))

#v(8pt)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 18pt,
  [
    #route(38, "View from the Top", "5.12c",
      "The crux at the lip is harder than it looks from the ground!",
      "Rick Willison, 2023")

    #route(39, "Hilltop Grouse", "5.12a",
      "Surprisingly easier than its neighbour to the left.",
      "Rick Willison, 2023")

    #project-route(40, "Open Project", "Prep Rick Willison", open: true)

    #route(41, "Molly's Crab Trap", "5.12d",
      "Steep and hard to read, but pretty nice once you work it out.",
      "Rick Willison, 2025")

    #route(42, "Tiers in Rain", "5.12c",
      "Tricky start into a cool roof feature. Engaging the whole way. Excellent!",
      "Rick Willison, 2025")
  ],
  [
    #route(43, "Gorilla Kibble", "5.12b",
      "Up the corner and around onto the face, where a shouldery crux awaits.",
      "Alex Ryan Tucker, 2024")

    #route(44, "Bitin' List", "5.12b",
      "A hard crux down low above the little roof, and a crimpy one to pass the bulge up high.",
      "Alex Ryan Tucker")

    #project-route(45, "In development", "Alex Ryan Tucker")

    #project-route(46, "In development", "Alex Ryan Tucker")
  ],
)

#v(0.4in)

#align(center)[
  #line(length: 3in, stroke: 0.5pt + divider)
  #v(8pt)
  #text(size: 8pt, fill: muted, tracking: 2pt, upper("End of guide · climb safe · pack it out"))
]
