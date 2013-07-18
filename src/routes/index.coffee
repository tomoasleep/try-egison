
#
# * GET home page.
# 
exports.index = (req, res) ->
  res.render "index",
    title: "Express"


exports.console = (req, res) ->
  res.render "console",
    title: "Console"

