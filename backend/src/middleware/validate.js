function validate(schema, source = 'body') {
  return (req, res, next) => {
    req.validated = schema.parse(req[source] ?? {});
    next();
  };
}

module.exports = validate;
