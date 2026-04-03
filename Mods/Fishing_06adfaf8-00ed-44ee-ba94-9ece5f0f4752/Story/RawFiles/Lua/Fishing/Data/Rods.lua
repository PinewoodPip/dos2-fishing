
local Rods = GetFeature("Fishing.Rods") ---@class Fishing.Rods

---Utility methods to register translated strings for a rod.
local RodNameTSK = function(tsk)
    tsk.ContextDescription = "Fishing rod item name"
    return Rods:RegisterTranslatedString(tsk)
end
local RodDescriptionTSK = function(tsk)
    tsk.ContextDescription = "Fishing rod item tooltip"
    return Rods:RegisterTranslatedString(tsk)
end

-- Register fishing rods.
---@type Fishing.Rod[]
local DefaultRods = {
    {
        ID = "Classic",
        Name = RodNameTSK{
            Handle = "h041b9d75g706cg4b9dg96d0gef41eab00c5b",
            Text = "Classic Fishing Rod",
        },
        Description = RodDescriptionTSK{
            Handle = "hbec4e294ga39eg4df6gae68gfc63162179c7",
            Text = [[A standard-issue fishing rod with a classic white and red bobber. Goes to show some things never go out of style.]],
        },
        RootTemplate = "90cdb693-3564-415a-a8fa-4027b7f76f41",
        VisualTemplate = "483ecb63-b01a-4452-be65-904d9ff03554",
        Bobber = {
            NormalColor = Color.CreateFromHex("BFBFBF"),
            HighlightColor = Color.CreateFromHex("D8D8D8"),
        },
    },
    {
        ID = "Shiny",
        Name = RodNameTSK{
            Handle = "h800f6c30g51b1g4bb2ga4e5g6b6b0063e64e",
            Text = "Shiny Fishing Rod",
        },
        Description = RodDescriptionTSK{
            Handle = "he22e5c9fg9455g4689gb139gcb97e9364698",
            Text = [[A fishing rod with a yellow bobber. It's got a nice sheen when held in the light. Very eye-catchy for the fish that have eyes.]],
            ContextDescription = [[Tooltip for fishing rod item]],
        },
        RootTemplate = "9fc3cb5f-894e-4783-9eef-fbceef0104b0",
        VisualTemplate = "5a14df6e-8e63-425c-9802-1916d630212e",
        Bobber = {
            NormalColor = Color.CreateFromHex(Color.LARIAN.GOLD),
            HighlightColor = Color.CreateFromHex(Color.LARIAN.YELLOW),
        },
    },
    {
        ID = "Fishy",
        Name = RodNameTSK{
            Handle = "ha4ffaf13g23c1g44b5g8a89g8e844f2ebc37",
            Text = "Fishy Fishing Rod",
        },
        Description = RodDescriptionTSK{
            Handle = "h490fd03dgf302g4026g801dg14b1aa82c408",
            Text = [[A fishing rod with a eye-catching, bright green rubber fish robber. This one's sure to attract bites quickly.]],
        },
        RootTemplate = "81cbf17f-cc71-4e09-9ab3-ca2a5cb0cefc",
        VisualTemplate = "c7639619-4c44-44a3-af53-81275a80af15",
        Bobber = {
            NormalColor = Color.CreateFromHex(Color.LARIAN.POISON_GREEN),
            HighlightColor = Color.CreateFromHex(Color.LARIAN.GREEN),
        },
    },
    {
        ID = "Master",
        Name = RodNameTSK{
            Handle = "h9d4f2871g3a5cg4e8bg91d0ga2c3b4d5e6f7",
            Text = "Master Fishing Rod",
        },
        Description = RodDescriptionTSK{
            Handle = "h0fed574fg7bf0g4074g84ebg147db6a4fbc7",
            Text = [[A wonderfully-crafted rod that's incredibly light and comfortable to hold. You feel ever more confident with it in your hands, knowing you proved you have the skills to wield it.<br>On its hilt sits a carving: "Masteer Rod" - sic.]],
        },
        RootTemplate = "56ac1e8f-6939-4bbc-b96d-5bc675f164ad",
        VisualTemplate = "1782b356-2560-4d04-8304-801bce9202cb",
        Bobber = {
            NormalColor = Color.CreateFromHex("5E50C2"),
            HighlightColor = Color.CreateFromHex(Color.TEAM_PINEWOOD.PIP_PURPLE),
        },
    },
    {
        ID = "Birch",
        Name = RodNameTSK{
            Handle = "h8c3e180bg2b4bg3d7ag80c9g91b2a3c4d5e6",
            Text = "Birchwood Fishing Rod",
        },
        Description = RodDescriptionTSK{
            Handle = "h5108d21ag4401g4c09ga1aag93041a14f8bf",
            Text = "A fishing rod made out of birch wood, with a heavy orange bobber. It's very durable and reliable - a great fishing partner in deep lakes.",
        },
        RootTemplate = "a2cc18cf-0264-4d7f-9898-f90a0d4e1b66",
        VisualTemplate = "8e0535fc-be48-4ffe-8649-cade6963e04f",
        Bobber = {
            NormalColor = Color.CreateFromHex("CE7321"),
            HighlightColor = Color.CreateFromHex("EF8F38"),
        },
    },
    {
        ID = "Sneaky",
        Name = RodNameTSK{
            Handle = "h7b2d070ag1a3ag2c6ag70b8g80a1b2c3d4e5",
            Text = "Camouflaged Fishing Rod",
        },
        Description = RodDescriptionTSK{
            Handle = "h452aab34gb800g45d5g8bc3g0d0c3a5adaf7",
            Text = "A fishing rod with a bobber designed to blend-in with both the water and the fishes. Though it sounds counter-productive at first, it helps to keep fish from escaping - as they'll never see the bobber coming to begin with.",
        },
        RootTemplate = "83279548-c03e-4d47-b437-84383f7c70c0",
        VisualTemplate = "06a1b6ca-9465-42a0-8e4e-2feb3345f81e",
        Bobber = {
            NormalColor = Color.CreateFromHex("4169E1"),
            HighlightColor = Color.CreateFromHex("5186E5"),
        },
    },
    {
        ID = "Cherry",
        Name = RodNameTSK{
            Handle = "h6a1c060bg0928g1b5ag60a7g7081a2b3c4d5",
            Text = "Cherry Fishing Rod",
        },
        Description = RodDescriptionTSK{
            Handle = "h216a9e58gd4f6g4b75ga410g31349b6b66c6",
            Text = "A pretty fishing rod made out of cherry wood, with a cute petal-styled bobber. Very romantic for fishing in rivers or clear lakes.",
        },
        RootTemplate = "7ce7111d-b57a-46b4-99aa-f02c89b0aebe",
        VisualTemplate = "98cac6fa-f8df-49ec-8d65-2007079b5c5f",
        Bobber = {
            NormalColor = Color.CreateFromHex("B86192"),
            HighlightColor = Color.CreateFromHex("E669B1"),
        },
    },
    {
        ID = "Crimson",
        Name = RodNameTSK{
            Handle = "h590b050cge707gf938g40c5g5060a1929384",
            Text = "Crimson Fishing Rod",
        },
        Description = RodDescriptionTSK{
            Handle = "h2ae959c7gd7aag482eg8601g317b6676b2cd",
            Text = "A rod imported from the Bloodmoon Island. If you whisper to it, it whispers back. Double-check any responses, as forbidden knowledge might lead to making mistakes.",
        },
        RootTemplate = "414b4ec9-00fe-4434-9c96-bc895c3e2003",
        VisualTemplate = "f964bad5-100d-4316-8d87-1ff385c2836a",
        Bobber = {
            NormalColor = Color.CreateFromHex("3D3D3D"),
            HighlightColor = Color.CreateFromHex("5A5A5A"),
        },
    },
    {
        ID = "Inverted",
        Name = RodNameTSK{
            Handle = "h4f8a040dgd616ge827g30d4g4050b0717182",
            Text = "Evil Fishing Rod",
        },
        Description = RodDescriptionTSK{
            Handle = "h3e44e917g5cfag491ag91deg6f628fc9c385",
            Text = "A rod made to fish with evil, twisted intentions that you cannot comprehend - that's why with great effort, you seek to have it overcome its nature.",
        },
        RootTemplate = "bc48a8ff-ccfd-4298-baef-60896240de44",
        VisualTemplate = "d7b3fc95-a6e4-45b4-9beb-95008cb0d59c",
        Bobber = {
            NormalColor = Color.CreateFromHex("911A00"),
            HighlightColor = Color.CreateFromHex("C54125"),
        },
    },
    {
        ID = "Livewood",
        Name = RodNameTSK{
            Handle = "h3e7930e4gc505gd716g20c3g304041615171",
            Text = "Livewood Fishing Rod",
        },
        Description = RodDescriptionTSK{
            Handle = "hd5c37f5egcb77g46d9gb58fgc9f4e077c7e5",
            Text = "A fishing rod made out of livewood logs. It hums with faint power. Carving reveals it originates from the Driftwood Sawmill, yet you've never seen such model sold anywhere...",
        },
        RootTemplate = "b73d6072-f730-4136-a102-1218196f92ef",
        VisualTemplate = "6009fd13-1915-4dea-ba51-3ded5f3e4743",
        Bobber = {
            NormalColor = Color.CreateFromHex("1BAEA3"),
            HighlightColor = Color.CreateFromHex("35E5D9"),
        },
    },
    {
        ID = "Spruce",
        Name = RodNameTSK{
            Handle = "h2d6820f3gb404gc605g10b2g203040514060",
            Text = "Spruce Fishing Rod",
        },
        Description = RodDescriptionTSK{
            Handle = "he8a548fdg1d03g40f5gbf1cg88b23835d085",
            Text = "A fishing rod made out of spruce wood. Highly elegant, with a dark green bobber that goes well both for aesthetics as well as attracting fish.",
        },
        RootTemplate = "117cfa77-27cf-41d8-9799-0bf7486cf2b3",
        VisualTemplate = "04ee7b4f-63bd-46ac-9f72-a9383081d6eb",
        Bobber = {
            NormalColor = Color.CreateFromHex("286B28"),
            HighlightColor = Color.CreateFromHex("2E952E"),
        },
    },
}
for _,rod in ipairs(DefaultRods) do
    Rods.RegisterRod(rod)
end
