require("Comment").setup({})

local comment_ft = require("Comment.ft")
comment_ft.set("lua", { "--%s", "--[[%s--]]" })
comment_ft.set("scss", { "//%s", "" })