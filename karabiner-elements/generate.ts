import {
  ArrowKeyCode,
  ControlOrSymbolKeyCode,
  ifApp,
  LayerKeyParam,
  LetterKeyCode,
  map,
  NumberKeyCode,
  rule,
  simlayer,
  StickyModifierKeyCode,
  withMapper,
  writeToProfile,
} from "https://deno.land/x/karabinerts@1.30.0/deno.ts";

const alphaNumericKeys = (
  "1234567890" +
  "qwertyuiop" +
  "asdfghjkl" +
  "zxcvbnm"
).split("") as (LetterKeyCode | NumberKeyCode)[];
const symbols = [
  "grave_accent_and_tilde",
  ...["hyphen", "equal_sign"],
  ...["open_bracket", "close_bracket", "backslash"],
  ...["semicolon", "quote"],
  ...["comma", "period", "slash"],
] as ControlOrSymbolKeyCode[];
const otherKeys = [
  "tab",
  "delete_or_backspace",
  "return_or_enter",
  "left_arrow",
  "right_arrow",
  "up_arrow",
  "down_arrow",
  "spacebar",
] as (ArrowKeyCode | ControlOrSymbolKeyCode)[];
const leftHomeRow = "sdfg".split("") as LetterKeyCode[];
const rightHomeRow = "hjkl".split("") as (LetterKeyCode)[];

/**
 * sequence: control < option < command < shift
 */
const homeRowSimLayer = (
  from_key: LayerKeyParam,
  to_modifier: StickyModifierKeyCode,
  excludeKeys: LayerKeyParam[],
) =>
  simlayer(from_key, `${from_key}-${to_modifier}-mode`).manipulators([
    withMapper(
      [...alphaNumericKeys, ...symbols, ...otherKeys].filter(
        (key) => !excludeKeys.includes(key),
      ),
    )((key) =>
      map(key, "optionalAny").to({ key_code: key, modifiers: [to_modifier] })
    ),
  ]);

writeToProfile("Default", [
  rule("caps-lock to left-control, escape if alone").manipulators([
    map("caps_lock", "optionalAny").to("left_control").toIfAlone("escape"),
  ]),
  rule("enter to right-control, enter if alone").manipulators([
    map("return_or_enter", "optionalAny")
      .to("right_control")
      .toIfAlone("return_or_enter"),
  ]),
  rule("escape to hyper").manipulators([map("escape").toHyper()]),
  homeRowSimLayer("g", "left_control", leftHomeRow),
  homeRowSimLayer("f", "left_shift", leftHomeRow),
  homeRowSimLayer("d", "left_command", leftHomeRow),
  homeRowSimLayer("s", "left_option", leftHomeRow),
  homeRowSimLayer("h", "right_control", rightHomeRow),
  homeRowSimLayer("j", "right_shift", rightHomeRow),
  homeRowSimLayer("k", "right_command", rightHomeRow),
  homeRowSimLayer("l", "right_option", rightHomeRow),
  simlayer("spacebar", "space-mode (code)").manipulators([
    // right side: enters
    map("u").to("return_or_enter", "left_command"), // command + enter
    map("m").to("return_or_enter", "left_shift"), // inline return
    map("i").to("return_or_enter"), // enter
    // p
    // right side: vim navigation
    map("h").to("left_arrow"), // vim left
    map("j").to("down_arrow"), // vim down
    map("k").to("up_arrow"), // vim up
    map("l").to("right_arrow"), // vim right
    // n
    // right side: symbols
    map("y").to("quote", "left_shift"), // "
    map("o").to("quote"), //  '
    // left side: brackets,
    map("s").to("open_bracket"), // [
    map("x").to("close_bracket"), // ]
    map("f").to("9", "left_shift"), // (
    map("v").to("0", "right_shift"), // )
    map("d").to("open_bracket", "left_shift"), // {
    map("c").to("close_bracket", "left_shift"), // }
    // left side: symbols
    map("g").to("grave_accent_and_tilde"), // ` (g)rave
    map("b").to("semicolon", "left_shift"), // ` colon :
    map("w").to("backslash", "left_shift"), // | wall
    map("r").to("hyphen", "left_shift"), // _ run(t)er
    map("e").to("equal_sign"), // = (e)qual
    map("t").to("grave_accent_and_tilde", "right_shift"), // ~ (t)ilde
    map("q").to("hyphen"), // -
    map("a").to(1, "right_shift"), // ! aaahhhh!
    map("z").to("slash", "left_shift"), // ?
  ]),
  simlayer("i", "i-mode (text manipulation and selection)").manipulators([
    map("u").to("left_arrow", ["left_shift", "option"]), // select word left
    map("o").to("right_arrow", ["left_shift", "option"]), // select word right
    map("q").to("delete_or_backspace", "left_command"), // undo word
    map("w").to("delete_or_backspace", "left_option"), // undo word
    map("e").to("delete_or_backspace"), // undo
    map("r").to("delete_forward"), // delete forward
    map("s").to("left_arrow", "option"),
    map("d").to("up_arrow", "option"),
    map("f").to("down_arrow", "option"),
    map("g").to("right_arrow", "option"),
    map("x").to("left_arrow", "command"),
    map("c").to("up_arrow", "command"),
    map("v").to("down_arrow", "command"),
    map("b").to("right_arrow", "command"),
  ]),
  simlayer(["v", "m"], "v-mode").manipulators([
    map("comma").to({ key_code: "left_arrow", modifiers: ["left_control"] }),
    map("period").to({ key_code: "right_arrow", modifiers: ["left_control"] }),
    map("c").toApp("Slack"), // chat
    map("e").toApp("IntelliJ IDEA Ultimate"),
    map("b").toApp("Safari"), // browser
    map("s").toApp("Signal"),
    map("f").toApp("Finder"),
    map("w").toApp("WhatsApp"),
    map("a").toApp("Dash"), // a b/c also used in e-mode
    map("j").toApp("iTerm"),
    map("k").toApp("Calendar"),
    map("u").toApp("Music"), // mUsic
    map("x").toApp("Mail"),
    map("y").toApp("Weather"),
  ]),
  simlayer("q", "q-mode for emojis").manipulators([
    map("u").toPaste("😅"),
    map("j").toPaste("👍🏼"),
    map("h").toPaste("👋🏼"), // (h)i
    map("m").toPaste("🤗"),
    map("t").toPaste("🤔"),
    map(",").toPaste("🙌🏼"),
    map("f").toPaste("🤦🏼‍♂️"),
    map("p").to("spacebar", ["left_control", "left_command"]),
  ]),
  simlayer("e").condition(
    ifApp("com.jetbrains.intellij", "IntelliJ IDEA Ultimate"),
  ).manipulators(
    [
      map("w").to("t", ["right_control", "right_shift"]),
      map("r").to("r", ["right_option", "left_shift"]),
      map("t").to("t", ["right_control", "right_shift"]),
      map("h").to("left_arrow", ["left_command", "left_option"]), // tab left
      map("j").to("p", ["left_shift", "left_command"]),
      map("k").to("f1", ["fn", "right_command"]),
      map("l").to("right_arrow", ["left_command", "left_option"]),
      map("y").to("semicolon", "left_control"), // ace jump
      map("u").to("7", ["left_shift", "left_command"]), // structure modal
      map("o").to("o", ["left_shift", "left_command"]),
      map("i").to("o", ["left_option", "left_command"]),
      map("f").to("f4", ["fn"]), // jump to source
      map("a").to("d", ["left_shift", "left_command"]),
      map("b").to("f3", ["right_command", "fn"]), // bookmarks | todo: could be removed b/c of vim binding
      map("p").to("p", ["left_shift", "left_option", "left_control"]), // recent projects
      map("n").to("f12", ["fn", "left_command", "left_shift"]), // hide all toolbars
      map("comma").to("up_arrow", [
        "left_shift",
        "left_control",
        "left_option",
      ]), // go to previous hunk
      map("period").to("down_arrow", [
        "left_shift",
        "left_control",
        "left_option",
      ]), // go to next hunk
      map("open_bracket").to("open_bracket", ["left_option", "left_command"]),
      map("close_bracket").to("close_bracket", ["left_option", "left_command"]),
      map("spacebar").to("1", [
        "left_shift",
        "left_control",
        "left_option",
        "left_command",
      ]),
    ],
  ),
  simlayer("c").condition(ifApp("com.tinyspeck.slackmacgap", "Slack"))
    .manipulators(
      [
        map("x").toPaste("@rg-test deploy cliniko to staging"),
        map("v").toPaste("@rg-test deploy cliniko to production"),
        map("m").toPaste("/remind me to check #deploy in 10 minutes"),
      ],
    ),
]);
