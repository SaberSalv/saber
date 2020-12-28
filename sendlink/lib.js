var pd = console.log.bind(console)

// lodash
_.set = function(key, value) { this[key] = value }

// rivets
rivets.configure({
  templateDelimiters: ["{{", "}}"],

  handler: function(target, event, binding) {
    var eventType = binding.args[0]
    var arg = target.getAttribute("arg")
    this.call(rivets.model, event, binding.model, arg)
  }
})

rivets.formatters.prefix = function(value, prefix) {
  return `${prefix}-${value}`
}
