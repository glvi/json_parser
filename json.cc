#include "json_parser.hh"
#include "json.hh"

/*
  Utilities
*/

using std::ostream;
using std::pair;
using std::string;
using std::ranges::range;

template<typename A, typename B>
static auto operator<<(ostream& out, pair<A,B> const& p) -> ostream&
{
  return out << p.first << ": " << p.second;
}

static auto enumerate(ostream& out, range auto const& rng) -> void
{
  auto last = std::end(rng);
  auto iter = std::begin(rng);
  if (iter != last) {
    out << *iter++;
    while (iter != last)
      out << ", " << *iter++;
  }
}

static auto print(ostream& out)
{
  return [&](auto const& value) -> ostream& {
    return out << value;
  };
}

/*
  JSONNull
*/

auto operator<<(ostream& out, JSONNull const&) -> ostream&
{
  return out << "null";
}

/*
  JSONBoolean
*/

auto operator<<(ostream& out, JSONBoolean const& j) -> ostream&
{
  return out << (j ? "true" : "false");
}

/*
  JSONNumber
*/

auto operator<<(ostream& out, JSONNumber const& j) -> ostream&
{
  return out << static_cast<double>(j);
}

/*
  JSONString
*/

JSONString::JSONString(string&& initialValue)
  : value { std::move(initialValue) }
{}

JSONString::JSONString(string const& initialValue)
  : value { initialValue }
{}

auto operator==(JSONString const& a, JSONString const& b) -> bool
{
  return a.value == b.value;
}

auto JSONString::Hash::operator()(JSONString const& s) const -> std::size_t
{
  using hash = std::hash<string>;
  return hash{}(s.value);
}

auto operator<<(ostream& out, JSONString const& j) -> ostream&
{
  out.put('\"');
  out << static_cast<string const&>(j);
  out.put('\"');
  return out;
}

/*
  JSONObject
*/

JSONObject::JSONObject(JSONString&& k, JSONValue&& j)
{
  mappings.emplace(std::move(k), std::move(j));
}

auto JSONObject::emplace(JSONString&& k, JSONValue&& j) -> void
{
  mappings.emplace(std::move(k), std::move(j));
}

auto JSONObject::at(JSONString const& k) const -> JSONValue const&
{
  static JSONValue null;
  auto it = mappings.find(k);
  if (it == mappings.end()) return null;
  return it->second;
}

auto operator<<(ostream& out, JSONObject const& o) -> ostream&
{
  out.put('{');
  enumerate(out, o.mappings);
  out.put('}');
  return out;
}

/*
  JSONArray
*/

JSONArray::JSONArray(JSONValue&& j)
{
  elements.push_back(std::move(j));
}

auto JSONArray::push_back(JSONValue&& j) -> void
{
  elements.push_back(std::move(j));
}

auto JSONArray::empty() const -> bool
{
  return elements.empty();
}

auto JSONArray::size() const -> size_type
{
  return elements.size();
}

auto JSONArray::at(size_type index) const -> JSONValue const&
{
  static JSONValue null;
  if (not (index < size())) return null;
  return elements.at(index);
}

auto operator<<(ostream& out, JSONArray const& a) -> ostream&
{
  out.put('[');
  enumerate(out, a.elements);
  out.put(']');
  return out;
}

/*
  JSONValue
*/

auto JSONValue::operator=(JSONNull) -> JSONValue&
{
  v = JSONNull{};
  return *this;
}

auto JSONValue::operator=(JSONBoolean b) -> JSONValue&
{
  v = std::move(b);
  return *this;
}

auto JSONValue::operator=(JSONNumber&& n) -> JSONValue&
{
  v = std::move(n);
  return *this;
}

auto JSONValue::operator=(JSONString&& s) -> JSONValue&
{
  v = std::move(s);
  return *this;
}

auto JSONValue::operator=(JSONObject&& o) -> JSONValue&
{
  v = std::move(o);
  return *this;
}

auto JSONValue::operator=(JSONArray&& a) -> JSONValue&
{
  v = std::move(a);
  return *this;
}

auto operator<<(ostream& out, JSONValue const& j) -> ostream&
{
  return std::visit(print(out), j.v);
}

/*
  Main
*/

auto main(int argc, char *argv[]) -> int
{
  Driver driver;
  yy::parser p {driver};
  p.parse();
  if (driver.result) {
    std::clog << "I found JSON: " << *driver.result << "\n";
    return EXIT_SUCCESS;
  } else {
    return EXIT_FAILURE;
  }
}
