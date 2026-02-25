
local Fishing = Epip.GetFeature("Features.Fishing")

---Utility method to register translated strings for a fish.
local T = function(tsk)
    return Fishing:RegisterTranslatedString(tsk).Handle
end

---@type table<string, Features.Fishing.Fish>
local fishes = {
    ["NormieShell"] = {
        NameHandle = T{
            Handle = "h04898eefg92d2g4324ga898g98ec374ba43c",
            Text = "Normie Shell",
        },
        DescriptionHandle = T{
            Handle = "h15bd7245g13c8g4d55ga9f2g9d78c2d2650c",
            Text = "A common shell. Many have awashed these shores, with many more yet to come. Free thinkers they are not.",
        },
        TemplateID = "0b65b8bb-d88c-48df-bd66-3fa66060fb52",
        Behaviour = "Sinker",
        Difficulty = 0.8,
    },
    ["BlueShell"] = {
        NameHandle = T{
            Handle = "hbcbc6bb1g16e5g488fg9fbdg8b58bea29838",
            Text = "Hydrated Shell",
        },
        DescriptionHandle = T{
            Handle = "hf6b7cbf8g87d9g4c1egba0ag3dcfd84084fc",
            Text = "A shell that has not forgotten its origins; it has embraced them. By returning to origin, it's able to hold onto what it deems dearest - its sea.",
        },
        TemplateID = "c5514b5f-e468-4908-a63d-0c33c07dadc4",
        Behaviour = "Chill",
        Difficulty = 0.9,
    },
    ["Handkerchief"] = {
        NameHandle = T{
            Handle = "h26e7f2b4g2ed5g4263g90degabc1968cfcda",
            Text = "Handkerchief",
        },
        DescriptionHandle = T{
            Handle = "h17093ee1gf109g4557g93c1g86107e034de1",
            Text = "A piece of cloth that has long forgotten the feel of its chief's hands.",
            ContextDescription = [[Fish description for Handkerchief; feel free to rewrite the description if the "pun" is inapplicable]],
        },
        TemplateID = "bc16aace-2992-46cd-982b-264b4507c2b6",
        Behaviour = "Floater",
        Difficulty = 0.8,
    },
    ["Scarf"] = {
        NameHandle = T{
            Handle = "hc276ceb6g8a9bg4b77gb218g3cd1a6de0a8b",
            Text = "Long Scarf",
        },
        DescriptionHandle = T{
            Handle = "h24fb5b04g64fdg4c6eg80fcgbc3730e04357",
            Text = "Long and meandering, this scarf always seems to slip off your neck, almost like an eel. A handmade one would surely work better.",
        },
        TemplateID = "72fd73e8-0331-4409-b822-7b092e0ceb1c",
        Behaviour = "Floater",
        Difficulty = 0.8,
    },
    ["BranchingCoral"] = {
        NameHandle = T{
            Handle = "hc9ede250g4509g4ccfg92a4g54b6cfe7320e",
            Text = "Branching Coral",
        },
        DescriptionHandle = T{
            Handle = "ha08eab2ag4acag4ef3g9c94gd368c93fcb22",
            Text = "By the coralflow workflow, its branches are clearly distinguished: main, developing, triage, released...",
        },
        TemplateID = "36da05e4-65d7-4c01-9ef0-190db1154bb6",
        Behaviour = "Chill",
        Difficulty = 1.2,
    },
    ["PearlClam"] = {
        NameHandle = T{
            Handle = "h1a3d6cf2g2397g4058gb3d0gbd0b439ec686",
            Text = "Pearl Clam",
        },
        DescriptionHandle = T{
            Handle = "hd39ce70ag0d20g4363ga76cg6b247a5c0313",
            Text = "A pearl blessed by the mermaids, and most importantly, the mercy of the many source hunters who returned it to the sea.",
        },
        TemplateID = "7a52514d-ec8d-4674-b60b-44589de635dd",
        Behaviour = "Chill",
        Difficulty = 1.5,
        Endurance = 1.2,
    },
    ["Starfish"] = {
        NameHandle = T{
            Handle = "haf6b2fdege245g4253gbb58gd47c039514cf",
            Text = "Starfish",
        },
        DescriptionHandle = T{
            Handle = "haeaca5e5gcb13g4b2ega6ccg91c803e3c986",
            Text = "A polygonous invertebrate, often mistakenly mixed into potions. Unsuccessful potions.",
        },
        TemplateID = "9c508a76-4e09-4747-a889-efcf8d18bb14",
        Behaviour = "Chill",
        Difficulty = 1.2,
        Endurance = 1.2,
    },
    ["SpikyConch"] = {
        NameHandle = T{
            Handle = "h2aa5e4a9g40feg43efgbe64gb0cc87bc5ae7",
            Text = "Spiky Conch",
        },
        DescriptionHandle = T{
            Handle = "h3558d4afgdce4g49f2g9e9dga3db8e56d32d",
            Text = "A conch that has adapted to the art of war. If fighting is sure to result in victory, then it must fight.",
        },
        TemplateID = "9ef3ea02-d89e-4e9a-abfe-980303207c6b",
        Behaviour = "Aggressive",
        Difficulty = 1.3,
        Endurance = 1.1,
    },
    ["WashedPanties"] = {
        NameHandle = T{
            Handle = "heaf10fc4g652bg4c37g998cg15c514da6b9f",
            Text = "Washed Panties",
        },
        DescriptionHandle = T{
            Handle = "h06e37630gfd2dg41b7gbf9bg77f386ad21ef",
            Text = "Though certainly more usable, the sea washed away all their backstory as well. Yet perhaps this paves the way for new fantasies and speculation.",
        },
        TemplateID = "36308031-2f2b-4ea7-abe3-6f4aaddc3dc2",
        Behaviour = "Floater",
        Difficulty = 1.5,
        Endurance = 0.9,
    },
    ["Pearl"] = {
        NameHandle = T{
            Handle = "hdbbd4a0agaad9g4ac3gbd9dgd5c23a42d882",
            Text = "Pearl",
        },
        DescriptionHandle = T{
            Handle = "h672bd6c6g587dg4e1eg95bbge9877f7a8e52",
            Text = "A curious fruit. You've heard of them before, yet they look nothing like how everyone else explained them to you. Surprisingly hard to digest.",
        },
        TemplateID = "bd05132f-a9f7-48a1-a9e1-ca8a47c95b01",
        Behaviour = "Chill",
        Difficulty = 2,
        Endurance = 0.8,
    },
    ["FishBone"] = {
        NameHandle = T{
            Handle = "hc048fb4cgfc3ag428cg9ad6gf3aee97e89e7",
            Text = "Fish Bones",
        },
        DescriptionHandle = T{
            Handle = "ha658d1c4gd626g44f3g8299g4a8571e66125",
            Text = "One could consider this specimen an outlier. It's clearly dead, and yet very much real - right here in your hands, not heaven nor hell.",
        },
        TemplateID = "0cca7d41-cb49-4956-b74f-6bc257212526",
        Behaviour = "Chill",
        Difficulty = 1.4,
    },
    ["Socks"] = {
        NameHandle = T{
            Handle = "had509ebag14efg4621gb1d1g14452f21a665",
            Text = "Socks",
        },
        DescriptionHandle = T{
            Handle = "h370c85d5g3efeg4ee0gaccfg50bd49c80280",
            Text = "Though born as twins and always living in pairs, these specimens often end up travelling mismatched. Yet rarely in stench outmatched.",
        },
        TemplateID = "83236aea-ab5b-486d-896d-73072996ec08",
        Behaviour = "Floater",
        Difficulty = 0.7,
    },
    ["CrystalCoral"] = {
        NameHandle = T{
            Handle = "h6442b39cge9c4g4ed3gaf1eg554d9ba4dcb6",
            Text = "Crystal Coral",
        },
        DescriptionHandle = T{
            Handle = "h0384bba5gd1cfg4e53g8d0cgb2943bb083b1",
            Text = "Its colors flash in a harmonized sequence. Other fauna appears attuned to them, obeying them to know when to stop to avoid collisions at intersections.",
        },
        TemplateID = "07fd4252-bcfe-4b30-870b-34e6ed306b85",
        Behaviour = "Chill",
        Difficulty = 1.5,
        Endurance = 1.1,
    },
    ["NonFineChina"] = {
        NameHandle = T{
            Handle = "h5ee9c166g3c4fg473fga0f0g28eda1513f2d",
            Text = "Non-fine China",
        },
        DescriptionHandle = T{
            Handle = "he2dee9eag3359g4d05gbdaagc00cdbdaa880",
            Text = "Crumbling and cracked, this piece can not be the creator's finest. Likely far less than the sum of its parts.",
        },
        TemplateID = "b38e07ef-2ac7-4bdb-9a1c-cf0aadc475e2",
        Behaviour = "Sinker",
        Difficulty = 1.2,
    },
    ["Corncomber"] = {
        NameHandle = T{
            Handle = "h2299e17eged84g4defg8cf2gc8974c279f07",
            Text = "Corncomber",
        },
        DescriptionHandle = T{
            Handle = "hdf50bb73g3a28g497bgbf01g95b1fcb62e7a",
            Text = "A slippery specimen that assaults from the back. Its scales make for quite the snack over an enclosed fire.",
        },
        TemplateID = "29983563-3ade-467f-8d9e-ff59f3446df9",
        Behaviour = "Sinker",
        Difficulty = 0.9,
        Endurance = 0.9,
    },
    ["MoonJelly"] = {
        NameHandle = T{
            Handle = "hffc054ccg3503g470egb1c9gebae2e05719e",
            Text = "Moon Jellies",
        },
        DescriptionHandle = T{
            Handle = "hb76cb59bg1d05g4a2bg9620geeeee3a93906",
            Text = "They don't taste as good as you expected. But the one above looks promising.",
        },
        TemplateID = "c95533e6-92b0-48a7-b7d9-8a9012bd9b07",
        Behaviour = "Chill",
        Difficulty = 1.3,
    },
    ["Gooseberry"] = {
        NameHandle = T{
            Handle = "ha375bdabg81c9g4efag9a2eg246e989bd92d",
            Text = "Gooseberries",
        },
        DescriptionHandle = T{
            Handle = "hc7c50099g8e27g40e8g9cc3gf451ce6da7ac",
            Text = "These pocket-sized jellies were only able to conglomerate into your hook with the power of friendship.",
        },
        TemplateID = "0105e2ce-98e5-4fc9-9552-8c30f4b22dc7",
        Behaviour = "Chill",
        Difficulty = 1,
    },
    ["DescentKey"] = {
        NameHandle = T{
            Handle = "h150aab2eg09d8g4466ga803g9fe81ec0085a",
            Text = "Descent Planar Key",
        },
        DescriptionHandle = T{
            Handle = "h10d2f1c4g8abbg4504gaaf0gaba52ee8c731",
            Text = "This alien relic teems with unkown (sic) power; you feel as though it could open the very space around you.",
            ContextDescription = [[Tooltip for Descent Navigation Key treasure; the unkown typo is intentional (from Ameranth), denoted by "(sic)"]],
        },
        TemplateID = "c9c8ad3b-9ee6-46c2-a5b0-8a228c57619a",
        Behaviour = "Sinker",
        Difficulty = 2.5,
        Endurance = 1.2,
    },
    ["GoldenShell"] = {
        NameHandle = T{
            Handle = "h8e9980f7gb1a9g46f7g9712g97f71bf34c21",
            Text = "Golden Shell",
        },
        DescriptionHandle = T{
            Handle = "h6d508058g0bc8g4d40g8706g34f12835fdef",
            Text = "A shell of particularly low durability, yet brimming with extraordinary enchantability.",
        },
        TemplateID = "85ea72e9-85fa-4338-8bf8-c50d4746f30e",
        Behaviour = "Chill",
        Difficulty = 0.9,
    },
    ["SeaPickle"] = {
        NameHandle = T{
            Handle = "h7187093ege4b0g400ag99d2gab4ff5af4ec3",
            Text = "Sea Pickle",
        },
        DescriptionHandle = T{
            Handle = "h38faf539gb941g401ag8d78g465f713bf475",
            Text = "The ground pickle almost sounds like it was a good invention after tasting this one.",
        },
        TemplateID = "b248d058-e2c4-465b-9fbe-479980b5df05",
        Behaviour = "Chill",
        Difficulty = 1,
    },
    ["Seaweed"] = {
        NameHandle = T{
            Handle = "h4cd5da0ag9577g44aegab8egf379f90f0067",
            Text = "Seaweed",
        },
        DescriptionHandle = T{
            Handle = "h5294aab7g78e8g450cg99c0g34f744f29997",
            Text = "A drifting algae. The lack of effective underwater mowing techniques results in them overcrowding beaches.",
        },
        TemplateID = "6d7b4477-85f1-4ec7-97bb-55c14a959e12",
        Behaviour = "Chill",
        Difficulty = 0.8,
        Endurance = 0.8,
    },
    ["SeabedRoll"] = {
        NameHandle = T{
            Handle = "hfa58df40gb0f1g4c9fga550g44245f352d7d",
            Text = "Seabed Roll",
        },
        DescriptionHandle = T{
            Handle = "h4c3ad81fgeee6g402bgbe08gc7258f340894",
            Text = "Dried seaweed, packed and rolled up for ease of transport. You can tell this idea will go places.",
        },
        TemplateID = "293f7126-7871-4970-b1be-8639d8bbb54b",
        Behaviour = "Sinker",
        Difficulty = 1.1,
    },
    ["TorrentedSoul"] = {
        NameHandle = T{
            Handle = "hc5602e5ag5489g4b09g9d21gb178e91c1f1e",
            Text = "Torrented Soul",
        },
        DescriptionHandle = T{
            Handle = "hf77bf2b5g6697g477egb9edg8922341e577c",
            Text = "Pitiful souls of those long lost to the torrents. Fated to but two destinies: to seed knowledge for those to come, or to leech from all.",
        },
        TemplateID = "0d547d36-340b-45f4-a9c4-c601fef20c31",
        Behaviour = "Aggressive",
        Difficulty = 1.4,
        Endurance = 1.5,
    },
    ["WaspNest"] = {
        NameHandle = T{
            Handle = "hd5d4be9fg168cg46c0ga01cg3c6b6cc940f0",
            Text = "Wasp Nest",
        },
        DescriptionHandle = T{
            Handle = "hf161e0d2ge62fg4ac2g9d35g961a3b785e3e",
            Text = "Life is full of surprises. Some surprises repeat. It's best not to assume you won't fish up another fucking wasp nest in the future.",
        },
        TemplateID = "ad130829-18f7-47f8-be8a-c211fb03d9be",
        Behaviour = "Aggressive",
        Difficulty = 1.5,
        Endurance = 1.2,
    },
    ["CrabClaw"] = {
        NameHandle = T{
            Handle = "hcc8e1875g2fafg4c97g9f7fg031df2430d3f",
            Text = "Crab Claw",
        },
        DescriptionHandle = T{
            Handle = "h81603a61ge217g4836g9855gb629fcc3e635",
            Text = "A gift from one of the few beings that values legacy. One crab's obsolete claw is another man's treasure.",
        },
        TemplateID = "367cd086-70d6-40d8-9d67-5e740c3a26bf",
        Behaviour = "Aggressive",
        Difficulty = 1.5,
        Endurance = 1.5,
    },
    ["Bucket"] = {
        NameHandle = T{
            Handle = "hbd10fe61gdc2bg4f46g955bgcc74c0d1a435",
            Text = "Water Bucket",
        },
        DescriptionHandle = T{
            Handle = "ha0d82ca5gd0fag415bg90a6g5efdc0f8c042",
            Text = "This is a wooden bucket. But there's more - this one already came pre-filled when you fished it up. Dear god...",
        },
        TemplateID = "ccd5a301-1c5b-4e23-a66e-d6de28d2a6ca",
        Behaviour = "Chill",
        Difficulty = 0.85,
        Endurance = 2,
    },
    ["LilyPad"] = {
        NameHandle = T{
            Handle = "hbcac7d5bg6983g4b82g9489gf55cc5d39cb7",
            Text = "Lily Pad",
        },
        DescriptionHandle = T{
            Handle = "h04c9179eg5dc7g4ec4gb1ccg157269fdd27c",
            Text = "A leaf of a water lily. Gorgeous where you got it from, a bit awkward in your backpack. Perhaps you could make an idyllic pond of your own.",
        },
        TemplateID = "88fb39e1-80be-4134-970b-8e216c14481e",
        Behaviour = "Floater",
        Difficulty = 0.7,
        Endurance = 1.2,
    },
    ["Aldrovanda"] = {
        NameHandle = T{
            Handle = "hfad16a85gec4dg474fgb33fg03b84b480a79",
            Text = "Aldrovanda",
        },
        DescriptionHandle = T{
            Handle = "h27b49591g4b75g49a8ga847g1c2ee63271f9",
            Text = "Spiky and sentient, its lack of a success catching flies has left it frustrated and rude. Towards you.",
        },
        TemplateID = "f203717d-c226-46c2-83f3-f7c371816380",
        Behaviour = "Aggressive",
        Difficulty = 1.3,
        Endurance = 1.1,
    },
    ["Blobfish"] = {
        NameHandle = T{
            Handle = "h494c30b8gf3d1g4716gb14bg8f791e7df649",
            Text = "Blobfish",
        },
        DescriptionHandle = T{
            Handle = "h95deb892g5fc5g44dfg99a3g4c8484a868e2",
            Text = "The look on its face gives it all away: these just aren't a good storage method for anything.",
        },
        TemplateID = "25df0fdd-5825-43ce-b68c-5b6ac5beb640",
        Behaviour = "Sinker",
        Difficulty = 1.1,
        Endurance = 1.5,
    },
    ["AxeHead"] = {
        NameHandle = T{
            Handle = "h5bbb6383g2bedg433cgaab5g9aef1f6a5b2b",
            Text = "Axe Head",
        },
        DescriptionHandle = T{
            Handle = "hdb544abcgc2c9g4eaaga13cge084ea1440b9",
            Text = "You could put together a solid cleaving weapon with a blade like this. If only crafting were real.",
        },
        TemplateID = "b7dfe5c3-b97a-48b9-b951-00e784a94fc9",
        Behaviour = "Sinker",
        Difficulty = 1.1,
        Endurance = 1.4,
    },
    ["Fetish"] = {
        NameHandle = T{
            Handle = "h5d0199fege71bg407dgad3eg3320b29b0215",
            Text = "Fetish",
        },
        DescriptionHandle = T{
            Handle = "h5b70de46g4563g41c2gaf51gccbe9f6bc2ad",
            Text = "A doll used in some kind of ritual. People aren't very open about owning them.",
        },
        TemplateID = "0e5517fd-8072-4dd6-91c3-dda9362d7a2b",
        Behaviour = "Chill",
        Difficulty = 1.2,
        Endurance = 1,
    },
    ["Painting"] = {
        NameHandle = T{
            Handle = "h4adbdc14g60cdg4984g8510gb19108adeaf8",
            Text = "Painting of a Fish",
        },
        DescriptionHandle = T{
            Handle = "hdf26394dg773bg49f6g8a9dgc2adac7e332f",
            Text = "In its prime, this painting would've been worth a fortune. The fish depicted is little more than bones now, though.",
        },
        TemplateID = "bb14222f-5d29-4d30-ab25-a0dc9f8cde3f",
        Behaviour = "Chill",
        Difficulty = 1.1,
        Endurance = 1.6,
    },
    ["Head"] = {
        NameHandle = T{
            Handle = "h1d88e437gd8beg4ba3g9f2dg0f0c5558494a",
            Text = "Someone's Head",
        },
        DescriptionHandle = T{
            Handle = "hf1d515fege5e2g4274g9f10ga04e3abaa9bc",
            Text = "You deal with these all the time, so why do the ones from the sea creep you out? It's not the smell, it's not the look, it's not the feel. Maybe it's the fact that this one was still alive before you fished it out.",
        },
        TemplateID = "62b40302-0708-413d-8632-684a77962bcd",
        Behaviour = "Chill",
        Difficulty = 1.3,
        Endurance = 0.9,
    },
    ["FloodRose"] = {
        NameHandle = T{
            Handle = "h7119269agfee3g46cdgae12g829838bd584e",
            Text = "Flood Rose",
        },
        DescriptionHandle = T{
            Handle = "h4eb35b37gebc0g4f24gbd64geab120cc6dd9",
            Text = "A rare rose that grows only in emerging streams. The turquoise petals smell like sparkling slush and pristine bathtubs.",
        },
        TemplateID = "556e0b21-8db5-4f91-9b92-ab8c088ee6b7",
        Behaviour = "Floater",
        Difficulty = 1.7,
        Endurance = 1,
    },
    ["Salt"] = {
        NameHandle = T{
            Handle = "hf7465499g7d67g410ag8fefga4424a44fcf5",
            Text = "Salt",
        },
        DescriptionHandle = T{
            Handle = "hd26f6d57gcd96g4830g96f1ge11286021445",
            Text = "An essential mineral; to get salty is to be living a good life.",
        },
        TemplateID = "ddf213ab-1f45-4f7a-987c-f7496630c947",
        Behaviour = "Sinker",
        Difficulty = 0.7,
        Endurance = 0.7,
    },
    ["MessagelessBottle"] = {
        NameHandle = T{
            Handle = "heec6ac2eg95f8g4cbdg9c2cgbadd6d0dd0b7",
            Text = "Messageless Bottle",
        },
        DescriptionHandle = T{
            Handle = "h4f605c48g36afg4abbg9890gb56670ba2854",
            Text = "It's empty? Perhaps someone got to it first, or perhaps it's just trolling. Either way rude of someone to have contributed an empty bottle.",
        },
        TemplateID = "edeb3a42-6b45-4618-b0ca-9cde19a92604",
        Behaviour = "Sinker",
        Difficulty = 0.9,
        Endurance = 1.2,
    },
    ["Mine"] = {
        NameHandle = T{
            Handle = "h88863896g3127g4391gb784g0e31c4817aa5",
            Text = "Mine",
        },
        DescriptionHandle = T{
            Handle = "h9c7cb05fg95e8g46f8g987dg4ab8c821f7cf",
            Text = "There's possibly up to 8 more of these near where it came from. You flagged the spot to sweep them later.",
        },
        TemplateID = "b69cfc00-1570-4fe0-afca-612e1288e0d0",
        Behaviour = "Sinker",
        Difficulty = 1.2,
        Endurance = 1.3,
    },
    ["Soap"] = {
        NameHandle = T{
            Handle = "hcc37403ag0522g4cb4g94dag0c6c53d93ead",
            Text = "Natural Soap",
        },
        DescriptionHandle = T{
            Handle = "h262e1e10g9cc3g4e9fgb77ag08d109dd9695",
            Text = "A bar of soap that's been naturally formed in a cave. The quality far surpasses the mass-conjured ones off the shelves.",
        },
        TemplateID = "e7d8e36e-9126-42ad-be26-ae784d05440b",
        Behaviour = "Chill",
        Difficulty = 0.8,
        Endurance = 0.9,
    },
    ["SharkTooth"] = {
        NameHandle = T{
            Handle = "h10d807c5geaaag4770ga9e6ge8c218beb791",
            Text = "Shark Tooth",
        },
        DescriptionHandle = T{
            Handle = "hc34a09c3g8e66g406dg9251g0aff745f414b",
            Text = "Long and scary, this single tooth is mere foreshadowing for what's to come (for you) if you keep being nosy about seas where you don't belong.",
        },
        TemplateID = "c9ea6c04-5d7b-4733-aa27-f6aa4ab8bd5a",
        Behaviour = "Chill",
        Difficulty = 1.3,
        Endurance = 0.8,
    },
    ["WaterRing"] = {
        NameHandle = T{
            Handle = "h9318cfaag47b6g4f4cg9a7cg1ab1095382fb",
            Text = "White Witch Ring",
        },
        DescriptionHandle = T{
            Handle = "h05d4e30cg58d0g43d1gbaecgaf6cba85c395",
            Text = "A ring with many jewels, said to have been worn by a renown witch of old. There's supposedly as many of them as jewels on each different one.",
        },
        TemplateID = "672d4807-70f6-462a-87e6-878ac2546bd0",
        Behaviour = "Sinker",
        Difficulty = 1.7,
        Endurance = 0.9,
    },
    ["SeaPork"] = {
        NameHandle = T{
            Handle = "h97244a53g64b0g43bag9565g7ff8ad0ec224",
            Text = "Sea Pork",
        },
        DescriptionHandle = T{
            Handle = "h01740a38g4e43g4d62g9ea1g4e4ca6219b9b",
            Text = "You must have a really generous patron from the Seven looking over you for a roasted pork to emerge from your hook. You can think of no other explanation.",
            ContextDescription = [[Description for Sea Pork; "Seven" refers to the seven divines]],
        },
        TemplateID = "5b9840b7-db3a-4202-a970-dafa97dfc638",
        Behaviour = "Aggressive",
        Difficulty = 2,
        Endurance = 1.2,
    },
    ["Quiver"] = {
        NameHandle = T{
            Handle = "haa568b2cg5f20g4591ga825geb12a86d2761",
            Text = "Quiver",
        },
        DescriptionHandle = T{
            Handle = "h4311b7fbgfd10g4244g85d2ge3b51cb29691",
            Text = "An elongated pouch. Its original purpose is hard to deduce, but it now appears to be very convenient for transporting arrows.",
        },
        TemplateID = "1f281ebd-b8ec-48f0-b2b0-e32acbe71f85",
        Behaviour = "Aggressive",
        Difficulty = 1.7,
        Endurance = 0.8,
    },
    ["Starstone"] = {
        NameHandle = T{
            Handle = "he36a56c9g47b5g4e49gae53g635deed9d6cd",
            Text = "Star Stone",
        },
        DescriptionHandle = T{
            Handle = "h1a5f6328gb07fg4361g9b7bg9ccab1f026df",
            Text = "Threads strongly infused with Source and said to heal every ailment imaginable, but only once. For this reason, the vast majority of them have survived to this day unused.",
        },
        TemplateID = "65cc0ad3-9296-4dd9-ad35-dfe47bc5a0ad",
        Behaviour = "Aggressive",
        Difficulty = 1.8,
        Endurance = 0.7,
    },
    ["BuffaloAmulet"] = {
        NameHandle = T{
            Handle = "hd3904411ge67bg4c53gb714g262b893f73e2",
            Text = "Buffalo Amulet",
        },
        DescriptionHandle = T{
            Handle = "h1439228cg7578g4226gb483g3d2a64732d05",
            Text = "A very random drop. You can't help but wonder what its creator was thinking.",
        },
        TemplateID = "028b6e15-30b9-4c7a-81b7-b4c4f9fa82df",
        Behaviour = "Aggressive",
        Difficulty = 1.9,
        Endurance = 1.7,
    },
    ["Dandelion"] = {
        NameHandle = T{
            Handle = "h52e45de7gaba7g4b15gbf7bg9fb0d2f8dbdd",
            Text = "Seandelion",
        },
        DescriptionHandle = T{
            Handle = "h94c2198bge351g4c4bgae5agc5485ae96bd5",
            Text = "A composite of florets, and common prey of otariidae, et al.",
        },
        TemplateID = "c9f7f6af-0770-4fc0-a4ec-f3cbbe33ebcc",
        Behaviour = "Sinker",
        Difficulty = 0.7,
        Endurance = 0.7,
    },
    ["TemporalGear"] = {
        NameHandle = T{
            Handle = "h790a6d91gafaag4231gb544g17136b9858b2",
            Text = "Temporal Gear",
        },
        DescriptionHandle = T{
            Handle = "hd8c7e05bgf2f8g4acagada9g297661b3c844",
            Text = "Shivering, yet somehow sturdy. Seems to endlessly turn a constant level of inertia, even when resisted.",
        },
        TemplateID = "9a13346b-63cc-42e4-9dc7-f04da5846cb2",
        Behaviour = "Sinker",
        Difficulty = 1.5,
        Endurance = 2.2,
    },
    ["Moss"] = {
        NameHandle = T{
            Handle = "h4e1d02ebg2eceg40fegb66cgbeb084fe1213",
            Text = "Moss",
        },
        DescriptionHandle = T{
            Handle = "h5168de61gf189g4ce1gbd69ga7d5e23eb22f",
            Text = "Damp clamp of leaves. Makes rocks look considerably cooler.",
        },
        TemplateID = "505d83a0-8001-4f86-975a-e007f19c7891",
        Behaviour = "Floater",
        Difficulty = 0.8,
        Endurance = 0.5,
    },
    ["ZandalorTrunks"] = {
        NameHandle = T{
            Handle = "h205d2699g9bebg482bgbfc5g68f7c57e23ea",
            Text = "Zandalor's Trunks",
        },
        DescriptionHandle = T{
            Handle = "hea62ebadgef66g4cbbgb1a1g1155b3917fa2",
            Text = [["There is truth, and there is the perception of it. You will find out later which of the two has been the helmsman of the course you steer."]],
        },
        TemplateID = "57e298f1-533a-481f-9743-ef03364e73b4",
        Behaviour = "Floater",
        Difficulty = 2,
        Endurance = 1.3,
    },
    ["SourceStarFish"] = {
        NameHandle = T{
            Handle = "hcbcd8f55gd9e0g4fa2g9eb5g7d248934dbaa",
            Text = "Source-Infused Starfish",
        },
        DescriptionHandle = T{
            Handle = "hf276bdadg4f18g4608g828fg60133277d25e",
            Text = [[A starfish strongly infused with magic, its source generation possibly lasting for months. They are said to "set potion" on those who consume them.]],
        },
        TemplateID = "8f6ba58a-b68f-436d-828f-3802def990f0",
        Behaviour = "Chill",
        Difficulty = 1.5,
        Endurance = 1,
    },
    ["LavoodooDoll"] = {
        NameHandle = T{
            Handle = "h3708d721g204ag4f9fgaa32geffa97a41483",
            Text = "Lavoodoo Doll",
        },
        DescriptionHandle = T{
            Handle = "h3e001085g5b6dg471ag97c9g75dd2fa2556b",
            Text = "But a relic of a bygone trend. Adventurers used to collect these quite proudly before reasoning was invented.",
        },
        TemplateID = "e869b3a4-adb1-4c4a-8a49-b52e0424049f",
        Behaviour = "Aggressive",
        Difficulty = 1.8,
        Endurance = 1.5,
    },
    ["Hurchin"] = {
        NameHandle = T{
            Handle = "h5fd3e867g472bg4ac9gb777g092be5c786e3",
            Text = "Hurchin",
        },
        DescriptionHandle = T{
            Handle = "h6626dcadg4527g4c13gadf9gf9fca025fc40",
            Text = "A portable spike ball. Once thrown at someone, taking it out is much more hurtful than becoming one with it.",
        },
        TemplateID = "fe731665-4318-462c-b384-a7f8b38444e5",
        Behaviour = "Aggressive",
        Difficulty = 1.5,
        Endurance = 0.8,
    },
    ["Anglerfish"] = {
        NameHandle = T{
            Handle = "hb096a28bg104bg4714gaa9aga1f5ad60062c",
            Text = "Anglerfish",
        },
        DescriptionHandle = T{
            Handle = "h55057eeag3a8cg4a35gbad9g30f514876e85",
            Text = "This fish used to be an angler just like you, before it took a hook to its fins.",
        },
        TemplateID = "132a0eff-89df-4ea4-a0a6-47fc7e45cfac",
        Behaviour = "Aggressive",
        Difficulty = 1.7,
        Endurance = 1.5,
    },
    ["BladeFish"] = {
        NameHandle = T{
            Handle = "h2eae1f4egaacag4dbfg8b25g03c1ceccda0b",
            Text = "Bladefish",
        },
        DescriptionHandle = T{
            Handle = "hc6ce455fgb096g4639g9aecg96e6352c7429",
            Text = "A species that designed itself for wielding to combat. All part of its parasitic mastermind plan to transcend beyond the aquatic habitat.",
        },
        TemplateID = "d098bb0e-fe5a-4b9c-90f0-84b278daf071",
        Behaviour = "Aggressive",
        Difficulty = 1.8,
        Endurance = 2,
    },
    ["Epipe"] = {
        NameHandle = T{
            Handle = "h6ca67d65gbc60g4fa0g860dg0baae2e03fb8",
            Text = "Epipe",
        },
        DescriptionHandle = T{
            Handle = "hd82dc7c0gd40bg498eg8cb5g6a4600987106",
            Text = "A particularly dear item. With one of these in your backpack, you feel confident all your interfaces are significantly improved. Years of dedication and support from Godwoken all over Rivellon have made it into something truly special, and an unforgettable part of their journeys.",
        },
        TemplateID = "9b6827a3-9f44-4179-803b-cf6deb9e943a",
        Behaviour = "Sinker",
        Difficulty = 1.2,
        Endurance = 2,
    },
    ["ModSettingsMenu"] = {
        NameHandle = T{
            Handle = "h952da678g626dg490eg92adgea5f4b0175ce",
            Text = "Mod Configuration Menu",
        },
        DescriptionHandle = T{
            Handle = "h5a46ae70g0713g47d9g81b1g14a344745395",
            Text = "In ancient times, such books were said to be the only way to tweak things to your liking. By having them speak to you. Seriously.",
        },
        TemplateID = "bda440bc-8218-4c6a-9ed6-124944b2507c",
        Behaviour = "Floater",
        Difficulty = 2, -- Hard difficulty since these shits were a pain to use
        Endurance = 0.7,
    },
    ["Frog"] = {
        NameHandle = T{
            Handle = "h8f0d8f23gc9a8g4e36g9e67g64dc8203217d",
            Text = "Frog",
        },
        DescriptionHandle = T{
            Handle = "hd4d1f012g156eg4370g9620gee9cc1543ace",
            Text = "The frog does not speak to you. Not yet. It is waiting for your approval by the council.",
        },
        TemplateID = "3aa90d30-60f2-465d-aa39-3cb35f2d6f04",
        Behaviour = "Aggressive",
        Difficulty = 1.3,
        Endurance = 0.8,
    },
    ["FidgetSpinner"] = {
        NameHandle = T{
            Handle = "h0b8a9292g6d0eg4b85ga35cg67cfc9654f12",
            Text = "Fidget Spinner",
        },
        DescriptionHandle = T{
            Handle = "hf8516715g387dg42a4g8f89gba705280b611",
            Text = "A divisive widget. Many find its perpetual stimulation a blessing, others, a curse.",
        },
        TemplateID = "bacdad7a-2ddb-4b6c-936a-424f4b32ae22",
        Behaviour = "Aggressive",
        Difficulty = 1,
        Endurance = 0.6,
    },
    ["GilledMushroom"] = {
        NameHandle = T{
            Handle = "h94a59117ge304g4873gb11fge9e0ce274065",
            Text = "Gilled Mushroom",
        },
        DescriptionHandle = T{
            Handle = "hee206712gcde6g44c3g9412gd626e59189e0",
            Text = "Quite the elusive specimen; these took notes from fish and learnt to breathe water to hide from foragers. They were not aware of fishing beforehand.",
        },
        TemplateID = "aba4a9bf-0779-4d07-b201-cb6247e641e5",
        Behaviour = "Floater",
        Difficulty = 1,
        Endurance = 0.8,
    },
    ["LetterOfWill"] = {
        NameHandle = T{
            Handle = "ha121bca8g648ag4b45ga5f8g60e0710ee83c",
            Text = "Letter of Willpower",
        },
        DescriptionHandle = T{
            Handle = "hc4273c9ag4d54g4cd4g9d57g060b3bd586fd",
            Text = "Wise people know a drawing allows for more legal loopholes than a thousand words. This letter cleverly keeps the owner's legacy away from the literate grasp of the law, by showing where it is instead of what it is.",
        },
        TemplateID = "f8b54ffe-2275-444f-8beb-305b464376a3",
        Behaviour = "Floater",
        Difficulty = 1.2,
        Endurance = 0.8,
    },
    ["Pomfret"] = {
        NameHandle = T{
            Handle = "hc15681eag1aebg4659ga09bg00afbbc639a1",
            Text = "Pomfret",
        },
        DescriptionHandle = T{
            Handle = "h14d7c947ga20cg4f85gabd4g9880d84eda8d",
            Text = "A common edible fish of white meat, typically occupying deep waters and deep stomachs.",
        },
        TemplateID = "e9789fb1-7cf3-45c8-918f-c8d056938e44",
        Behaviour = "Chill",
        Difficulty = 0.9,
        Endurance = 0.9,
    },
    ["PolyamorousTrout"] = {
        NameHandle = T{
            Handle = "h7cbc9f9dg7c88g4534gae14ge6e5d7f01ff8",
            Text = "Polyamorous Trout",
        },
        DescriptionHandle = T{
            Handle = "h199dc6aeg997cg4016gb0ceg53a771bed96f",
            Text = "Subspecies of trout that have become aware of their single life, and that they should live with no regrets.",
        },
        TemplateID = "a4ae0f15-9326-454f-8e4b-515a593bd0b5",
        Behaviour = "Aggressive",
        Difficulty = 1.4,
        Endurance = 1,
    },
    ["ProperSeafarer"] = {
        NameHandle = T{
            Handle = "h7a4031f4g363bg47a3ga8efg9b3f3b28e401",
            Text = "Proper Seafarer",
        },
        DescriptionHandle = T{
            Handle = "h7eb0a32fgbeb4g4077g9024g6e0efdce7216",
            Text = "A full-on ship with all amenities included (except the crew)!!! It's crazy to think how many people voted against it.",
        },
        TemplateID = "b7acdcab-3c9f-4361-ad9f-6d77ab963c0b",
        Behaviour = "Floater",
        Difficulty = 0.7,
        Endurance = 2.5,
    },
    ["SmallShip"] = {
        NameHandle = T{
            Handle = "h7d7e0d65ge32bg49e6gbb1ega075de42441a",
            Text = "Small Ship",
        },
        DescriptionHandle = T{
            Handle = "ha96c27d9g4070g4396g869cg0df7376c4d95",
            Text = "A ship that's suspiciously small. Though functional, it's unclear who would've helmed it. Ants?",
        },
        TemplateID = "2b71a6da-4bef-4340-b7c5-a6c6375648d4",
        Behaviour = "Floater",
        Difficulty = 1,
        Endurance = 1,
    },
    ["Pitcher"] = {
        NameHandle = T{
            Handle = "hf893695bg2583g46d9g80begc633361d70b7",
            Text = "Pitcher",
        },
        DescriptionHandle = T{
            Handle = "hb335718dgbe99g48fbgac63ga97a5ec65171",
            Text = "A decent-looking water pitcher. With good persuasion, you could pitch it to just about anyone who doesn't need one.",
        },
        TemplateID = "e7face96-91f3-403d-ae13-68097f825773",
        Behaviour = "Sinker",
        Difficulty = 1.3,
        Endurance = 1,
    },
    ["PremoldedCheese"] = {
        NameHandle = T{
            Handle = "hcff03646g3ec1g471cgaaa6g3cecfb46b4b9",
            Text = "Premolded Cheese",
        },
        DescriptionHandle = T{
            Handle = "hb920a74cgbb2dg4340g8891gaeb561017afd",
            Text = "Being not in the mood is no longer a real excuse with these. You get to skip the wait and get right to the good part!",
        },
        TemplateID = "154d293b-694c-4991-aea4-30a095b090a2",
        Behaviour = "Chill",
        Difficulty = 1.2,
        Endurance = 0.8,
    },
    ["PotLid"] = {
        NameHandle = T{
            Handle = "h1116e016g071eg42f3g9829g8f88d123993e",
            Text = "Pot Lid",
        },
        DescriptionHandle = T{
            Handle = "h9fb2a632gdb3bg471cg812egc95da15b5696",
            Text = "It's invigorating to think about how much inconvenience you're actively causing by owning this. Now there's a pot out there that cannot be closed.",
        },
        TemplateID = "bae1c58f-b1f6-44fc-90ee-8e7ed9b31b3e",
        Behaviour = "Chill",
        Difficulty = 1.1,
        Endurance = 0.7,
    },
    ["Riftling"] = {
        NameHandle = T{
            Handle = "hfe9791dbgeedfg475ega325g8a28a492a2e5",
            Text = "Riftling",
        },
        DescriptionHandle = T{
            Handle = "h584dedb0gc8e3g4089g82bagd1027910a2f4",
            Text = "A fish summoned from another world. Its time is ticking, and you'd better show it the best parts of Rivellon while it's here. Your favorite fishing spot, maybe?",
        },
        TemplateID = "8ed3ce7d-6694-4114-bb99-1e802f5d79a3",
        Behaviour = "Aggressive",
        Difficulty = 1.4,
        Endurance = 0.8,
    },
    ["Pufferfish"] = {
        NameHandle = T{
            Handle = "ha73702f5g642cg4049ga393g88e3fafab5e8",
            Text = "Pufferfish",
        },
        DescriptionHandle = T{
            Handle = "h70c6cd4eg69e0g40e8gb333g7177f4526042",
            Text = "Yet another variety of a ball of spikes. This one a lot trickier to handle, as once you let go off it, the laws of gravity only allow it to go up.",
        },
        TemplateID = "313023ca-41bf-4781-ac17-ad102d08005b",
        Behaviour = "Aggressive",
        Difficulty = 1.2,
        Endurance = 0.7,
    },
    ["ReptileEgg"] = {
        NameHandle = T{
            Handle = "hf68a90cegb057g42f7ga764g3e8468a6e3a6",
            Text = "Reptile Egg",
        },
        DescriptionHandle = T{
            Handle = "h4ad4b9ddgb445g4088gaac9g614aa6e586a7",
            Text = "A great future companion. But how will you get it through the border?",
        },
        TemplateID = "3fd1f2ad-e2de-40ec-9348-176c62f3d772",
        Behaviour = "Chill",
        Difficulty = 0.7,
        Endurance = 1.2,
    },
    ["Piranha"] = {
        NameHandle = T{
            Handle = "h6ba88f91gcb67g4cc9g8136gf37ee80762d6",
            Text = "Piñanha",
            ContextDescription = [[Fish name; pun between "piñata" and "piranha"]],
        },
        DescriptionHandle = T{
            Handle = "h2e888e75ge508g47d8gabc0g78393a8efec8",
            Text = "A carnivorous, somewhat dangerous kind. And with danger always comes great loot inside.",
        },
        TemplateID = "445d0bee-b1d7-4f28-b4c2-18cf02632200",
        Behaviour = "Aggressive",
        Difficulty = 1.1,
        Endurance = 1.2,
    },
    ["Porgy"] = {
        NameHandle = T{
            Handle = "h22b2e592g6e13g4eebga759g82f36831377b",
            Text = "Porgy",
        },
        DescriptionHandle = T{
            Handle = "hbc594d01gffa5g4980ga2f9gf0cf6631e1e2",
            Text = "A ray-finned fish. Over 150 subspecies exist, and they all breed with each other quite hard.",
        },
        TemplateID = "dc888c65-6d68-4597-af24-41b9489ca8eb",
        Behaviour = "Chill",
        Difficulty = 0.8,
        Endurance = 0.9,
    },
    ["Bream"] = {
        NameHandle = T{
            Handle = "h11cd3dd7gfe47g47f9gb0d2gb03296cefa6d",
            Text = "Bream",
        },
        DescriptionHandle = T{
            Handle = "hda0ec7ddgd217g441agb76cg60811442a66a",
            Text = "Freshwater fish that are the bane of many unprepared adventurers, as their long-range beam can highly effectively take out uninformed bypassers.",
        },
        TemplateID = "edde3c85-cbd3-42cb-9567-567497473691",
        Behaviour = "Chill",
        Difficulty = 0.9,
        Endurance = 1.1,
    },
    ["SoulJar"] = {
        NameHandle = T{
            Handle = "h7eb50b4fgca87g437fgac4bg96c62fcbe46e",
            Text = "Soul Jar",
        },
        DescriptionHandle = T{
            Handle = "hd5a5c46cgaa85g40a0g8d3ag0a0d4ce152c9",
            Text = "You dredged this lost soul from the deep. It seems content with just being with company again at last. Would releasing it even be the moral thing to do?",
        },
        TemplateID = "0d547d36-340b-45f4-a9c4-c601fef20c31",
        Behaviour = "Sinker",
        Difficulty = 1.5,
        Endurance = 0.9,
    },
    ["SourceTouchedSchool"] = {
        NameHandle = T{
            Handle = "h850ffb4cg0110g49eag91bfgc7e86c5d332c",
            Text = "Source-touched School of Fish",
        },
        DescriptionHandle = T{
            Handle = "heb4168f7gdfcdg4c59ga3ecg4bc65a124374",
            Text = "A class of fish schooled in sourcery. Very old sourcery. You can tell they know a lot about source rushing - should you tell them?",
        },
        TemplateID = "86eecf19-fdff-492f-81f5-695ac4662e93",
        Behaviour = "Chill",
        Difficulty = 0.9,
        Endurance = 1.1,
    },
    ["SpareLamp"] = {
        NameHandle = T{
            Handle = "h94c13bacg8822g43e6gb0f7g3906d23ab57f",
            Text = "Spare Lamp",
        },
        DescriptionHandle = T{
            Handle = "hece3ad55gf7cbg4570g99bdg8abffd3eebe0",
            Text = "It's never wise to adventure without a backup plan for when your wishes run out. Carrying these is just common sense.",
        },
        TemplateID = "fa648321-84f5-4658-abda-35a1d20ccf5b",
        Behaviour = "Chill",
        Difficulty = 1.2,
        Endurance = 1.2,
    },
    ["Rockfish"] = {
        NameHandle = T{
            Handle = "h59ca494ag63d0g4700gb6b1g2a566962e6e8",
            Text = "Rockfish",
        },
        DescriptionHandle = T{
            Handle = "hfa4c584ag5120g4c20g97e3g3c155902196b",
            Text = "A fish that has not been exposed to the elements, but rather embraced them, becoming fortified and immune to being teleported.",
        },
        TemplateID = "853c1ec4-44cb-4bd7-8fa3-8a0377355f8d",
        Behaviour = "Sinker",
        Difficulty = 1.3,
        Endurance = 1.4,
    },
    ["Sludge"] = {
        NameHandle = T{
            Handle = "h47b091a7gf320g4284gb416g59cdf75d2b19",
            Text = "Sludge",
        },
        DescriptionHandle = T{
            Handle = "hf83b28d5g2be9g4e29g943aga461df0e65b2",
            Text = "Some things are best left unfished.",
        },
        TemplateID = "63a1d6eb-9e21-4997-82b2-87fa040131b3",
        Behaviour = "Floater",
        Difficulty = 0.5,
        Endurance = 0.6,
    },
    ["Stringfish"] = {
        NameHandle = T{
            Handle = "ha9c025bfg69a2g4addgb7b3g41110ce28c24",
            Text = "Stringfish",
        },
        DescriptionHandle = T{
            Handle = "hcdd65e90gdaa9g4ecbga3d3gf27d9b44fd87",
            Text = "Art imitates nature. In this case, it seems the art of life imitated a wooden bow.",
        },
        TemplateID = "f8f9df3f-6db4-4908-9e67-69cbbbc6b6e1",
        Behaviour = "Aggressive",
        Difficulty = 1.2,
        Endurance = 0.8,
    },
    ["Swordine"] = {
        NameHandle = T{
            Handle = "h95fb4399g8e05g42d7ga955gf3034cfe8dd5",
            Text = "Swordine",
        },
        DescriptionHandle = T{
            Handle = "hde0a214cgcceeg4cb1ga27agcb501165e364",
            Text = "Small but deadly in the right hands. You could bring a pocket full of these to a fight. Your right pocket. That way you could pull them out with your right hands.",
        },
        TemplateID = "e1ff43c5-b5a1-4b3e-ac28-18ea1851927d",
        Behaviour = "Aggressive",
        Difficulty = 1.3,
        Endurance = 0.8,
    },
    ["LightAtTheEnd"] = {
        NameHandle = T{
            Handle = "h7b70c51ag2927g4421g9d9cg2957bc787da3",
            Text = "Light at the end of the journey",
        },
        DescriptionHandle = T{
            Handle = "h454db5c6gc52cg4708gab9ag2ca51b8a96a7",
            Text = "Morbid curiosity keeps tempting you to take a peek into this flickering light - to see how your journey ends. With such insight, maybe you could end it better.",
        },
        TemplateID = "c4032bb5-9c30-4b63-bde9-3d8a667b2a52",
        Behaviour = "Chill",
        Difficulty = 1.2,
        Endurance = 1.2,
    },
    ["Petri"] = {
        NameHandle = T{
            Handle = "he878d384g2633g41a5g86b6gcf8f52e0c11c",
            Text = "Petri",
        },
        DescriptionHandle = T{
            Handle = "hc4e1c267g2afbg4dd8g9dc0g5401da5cc62d",
            Text = "Silverware with microscopic fishes on it that were otherwise completely unknown and unfishable until the invention of plates.",
        },
        TemplateID = "6d828b59-1439-4dc8-b045-69375f261679",
        Behaviour = "Chill",
        Difficulty = 0.5,
        Endurance = 0.9,
    },
    ["HotShell"] = {
        NameHandle = T{
            Handle = "h70e8e6e9gea1dg4164gb76dg36265f4dafce",
            Text = "Hot Shell",
        },
        DescriptionHandle = T{
            Handle = "h9557a4f2g59eeg41e7g9f16g2d1c6307c8e3",
            Text = "Similar to spiky shells, these have learnt to fight back predators, but smarter instead of harder.",
        },
        TemplateID = "0a6537b9-d25e-4615-adfc-3664bad98971",
        Behaviour = "Chill",
        Difficulty = 1.2,
        Endurance = 0.7,
    },
    ["Jackpot"] = {
        NameHandle = T{
            Handle = "h8daa22ccg3a49g4a49gb166g0b86b0622e5b",
            Text = "Jackpot",
        },
        DescriptionHandle = T{
            Handle = "hbeb9e313gb320g41ebga92bgc644a392ce91",
            Text = "Teach a man to fish and he'll eat for a day. Teach him vertical scaling and he'll peak in high school.",
        },
        TemplateID = "bcc3f515-9f52-4873-9d32-8f99524a3dd7",
        Behaviour = "Sinker",
        Difficulty = 1.1,
        Endurance = 2,
    },
    ["PyrokineticSnapper"] = {
        NameHandle = T{
            Handle = "hd9b7063dgd71dg43c5g85e1g318a53b3d5fe",
            Text = "Pyrokinetic Snapper",
        },
        DescriptionHandle = T{
            Handle = "hb7e4192eg25cbg4425ga8b7g8fe47ed63297",
            Text = "A variant of the snapper that can theoretically create fire by snapping its fins. Theoretically, due to environmental factors that get in the way.",
        },
        TemplateID = "d34559fe-70e0-49cd-a10e-918b20912e98",
        Behaviour = "Aggressive",
        Difficulty = 1.3,
        Endurance = 0.8,
    },
    ["RedHerring"] = {
        NameHandle = T{
            Handle = "h4b743141gecebg450bg8240g8ef2713c16e2",
            Text = "Red Herring",
        },
        DescriptionHandle = T{
            Handle = "h2693b604g71e1g4f98g8e3dg93e21a1e0667",
            Text = "You went quite out of your way to catch it, and yet, you can't help but feel you're on the wrong track.",
        },
        TemplateID = "60aea63a-a991-4a4d-bfdf-b711b0110628",
        Behaviour = "Chill",
        Difficulty = 0.8,
        Endurance = 1,
    },
    ["SardineSchool"] = {
        NameHandle = T{
            Handle = "hf3592bbfg4847g4e6dg84f9g0a841c603bf1",
            Text = "Party of Sardines",
        },
        DescriptionHandle = T{
            Handle = "hc6d5922fg4001g4718gb131ga900853bf289",
            Text = "A group of sardines that clinged onto your hook all at once. For ease of logistics and taxes, you decided to interpret them as a single unit. A macro fish.",
        },
        TemplateID = "78944354-d4bf-42c9-b027-d9628f844354",
        Behaviour = "Chill",
        Difficulty = 0.9,
        Endurance = 2,
    },
    ["Sardine"] = {
        NameHandle = T{
            Handle = "h9f6e1809gfa55g441cg8db5g0a6ca5f69afb",
            Text = "Sardine",
        },
        DescriptionHandle = T{
            Handle = "h3a4eadd6ga76eg4bbbgbbd7g88046ed70993",
            Text = "A small fish migrating from legacy oceans. Did not come with its original packaging.",
        },
        TemplateID = "f9a179cf-d45b-4db6-9323-2dc0b2a2dc92",
        Behaviour = "Chill",
        Difficulty = 0.7,
        Endurance = 0.8,
    },
    ["Mindflayer"] = {
        NameHandle = T{
            Handle = "h06d65a11gd735g4d3fg94c2g63d4bdd95607",
            Text = "Mindflayer",
        },
        DescriptionHandle = T{
            Handle = "h6264a4e6gcec7g48ccg8921gd00d5fdf51f5",
            Text = "A bald aberration that dwells in moist caves and bosses people around. All your opinions are their own. Always have been.",
        },
        TemplateID = "2ead8fd3-dc37-4064-99ca-4d075db0c897",
        Behaviour = "Aggressive",
        Difficulty = 1.4,
        Endurance = 1.2,
    },
    ["Eel"] = {
        NameHandle = T{
            Handle = "he6d54861g61e7g49f1g81a7gd0dcac15826f",
            Text = "Eel",
        },
        DescriptionHandle = T{
            Handle = "h22fd4ad9g04c2g4044g9168g85aced38c7e2",
            Text = [[A long, slimy fish that lives in dark waters and can spell "aerotheurge" correctly.]],
        },
        TemplateID = "efccb705-f51f-4d34-bbe3-1e9c3fcbcf7b",
        Behaviour = "Sinker",
        Difficulty = 0.7,
        Endurance = 1.2,
    },
    ["DarkConch"] = {
        NameHandle = T{
            Handle = "hff08446ag9354g481cg9136gda32496a2556",
            Text = "Dark Conch",
        },
        DescriptionHandle = T{
            Handle = "h23357919g084eg4f6eg8128g3f71716fcb95",
            Text = "Conches that are lawfully evil. Many necronchmasters have tried to turn them, but their stubberness is unmatched - they will only ever commit crimes that are legal.",
        },
        TemplateID = "59b35035-fceb-4673-a089-e3f956a61f86",
        Behaviour = "Aggressive",
        Difficulty = 0.7,
        Endurance = 1,
    },
    ["Nightfarer"] = {
        NameHandle = T{
            Handle = "ha9f1c67eg614ag44e5g99b8g869125c12ef1",
            Text = "Nightfarer",
        },
        DescriptionHandle = T{
            Handle = "hc2625a80gcfd0g46a2ga45eg656060dbfd6c",
            Text = "A void-touched fish that has never been caught at night. Their only weakness is the other part of the day.",
        },
        TemplateID = "3e59c0fa-dc33-4ec3-849b-07c67c46664d",
        Behaviour = "Chill",
        Difficulty = 1.2,
        Endurance = 1.2,
    },
    ["GripSlipper"] = {
        NameHandle = T{
            Handle = "h9918d8e5gdb17g4c38gbad5ga27494928ba4",
            Text = "Grip Slipper",
        },
        DescriptionHandle = T{
            Handle = "h48c7f160gbc69g467ag9c6dgde7aa828dd26",
            Text = "An eel that has lost all grip on reality from prolonged contact with the void. It desires nothing but to continue sharing nonsense with its colleagues, in a private stream you cannot access.",
        },
        TemplateID = "2d76c20d-ed93-4862-9248-b2d983be588b",
        Behaviour = "Floater",
        Difficulty = 2.5,
        Endurance = 0.9,
    },
    ["GenericVoidwoken"] = {
        NameHandle = T{
            Handle = "h8a4f1aa0geec5g4012gb8eeg5ddc257d8811",
            Text = "Void-touched Fish",
        },
        DescriptionHandle = T{
            Handle = "haea9efe6gdfadg4263g939bg73b00356aa46",
            Text = "A fish that has been immersed in the void and lost all its identifying features.",
        },
        TemplateID = "c823c188-308d-4f4c-a27a-03086efba15e",
        Behaviour = "Aggressive",
        Difficulty = 1.2,
        Endurance = 1.2,
    },
}
for id,fish in pairs(fishes) do
    fish.ID = id

    -- Add generic context descriptions to TSKs
    local nameTSK = Text.GetTranslatedStringData(fish.NameHandle)
    local descriptionTSK = Text.GetTranslatedStringData(fish.DescriptionHandle)
    if not nameTSK.ContextDescription then
        nameTSK.ContextDescription = "Fish name"
    end
    if not descriptionTSK.ContextDescription then
        descriptionTSK.ContextDescription = "Fish tooltip for " .. nameTSK.Text
    end

    Fishing.RegisterFish(fish)
end
