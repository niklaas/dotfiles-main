
import * as React from "react"
import * as Oni from "oni-api"

export const activate = (oni: Oni.Plugin.Api) => {
    console.log("config activated")

    // Input
    //
    // Add input bindings here:
    //
    oni.input.bind("<c-enter>", () => console.log("Control+Enter was pressed"))

    //
    // Or remove the default bindings here by uncommenting the below line:
    //
    // oni.input.unbind("<c-p>")

}

export const deactivate = (oni: Oni.Plugin.Api) => {
    console.log("config deactivated")
}

export const configuration = {
    //add custom config here, such as

    "ui.colorscheme": "nord",

    "oni.useDefaultConfig": false,
    "oni.bookmarks": ["~/Files"],
    "oni.loadInitVim": "~/init.vim",
    "editor.fontSize": "14px",
    //"editor.fontFamily": "Monaco",

    // UI customizations
    "ui.animations.enabled": true,
    "ui.fontSmoothing": "auto",

    // Prune extras and get a vim-like feeling
    // https://github.com/onivim/oni/wiki/How-To:-Minimal-Oni-Configuration
    "oni.hideMenu": true,
    "learning.enabled": false
    "achievements.enabled": false

    // Language servers
    "language.elixir.languageServer.command": "~/Files/elixir-ls/language_server.bat",
    "language.elixir.languageServer.arguments": ["--stdio"],
    "language.elixir.languageServer.rootFiles": ["mix.exs"],
    "language.elixir.languageServer.configuration": {}
}
