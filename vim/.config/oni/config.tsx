import * as React from "react"
import * as Oni from "oni-api"

export const activate = (oni: Oni.Plugin.Api) => {
  oni.input.unbind("<c-g>") // make C-g work as expected in vim
  oni.input.unbind("<c-v>") // make C-v work as expected in vim
}

export const configuration = {
  activate,
  "oni.loadInitVim": true,
  "oni.useDefaultConfig": false,

  "editor.fontFamily": "Fira Code",
  "editor.fontSize": "14px",

  "ui.animations.enabled": true,
  "ui.fontSmoothing": "auto",
  "ui.colorscheme": "nord",

  "oni.hideMenu": true,
  "learning.enabled": false,
  "achievements.enabled": false,
}
