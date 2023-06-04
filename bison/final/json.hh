#pragma once
#include <iosfwd>
#include <optional>
#include <string>
#include <unordered_map>
#include <variant>
#include <vector>

/*
  JSON unit type
*/

class JSONNull
{
};

auto operator<<(std::ostream&, JSONNull const&) -> std::ostream&;

static constexpr JSONNull const JSON_NULL = {};

/*
  JSON Boolean type
*/

class JSONBoolean
{
  bool value = false;

public:
  explicit constexpr JSONBoolean() = default;
  explicit constexpr JSONBoolean(bool initialValue) noexcept : value { initialValue }
  {
  }
  explicit constexpr operator bool() const noexcept
  {
    return value;
  }
};

auto operator<<(std::ostream&, JSONBoolean const&) -> std::ostream&;

static constexpr JSONBoolean const JSON_FALSE;
static constexpr JSONBoolean const JSON_TRUE{true};

/*
  JSON numerical type
*/

class JSONNumber
{
  double value = 0.0;

public:
  explicit constexpr JSONNumber() = default;
  explicit constexpr JSONNumber(double initialValue) noexcept
    : value { initialValue }
  {}
  explicit constexpr operator double() const noexcept
  {
    return value;
  }
};

auto operator<<(std::ostream&, JSONNumber const&) -> std::ostream&;

/*
  JSON string type
*/

class JSONString
{
  std::string value;

public:
  explicit JSONString() = default;
  explicit JSONString(std::string&&);
  explicit JSONString(std::string const&);
  explicit constexpr operator std::string const&() const noexcept
  {
    return value;
  }
  friend auto operator==(JSONString const&, JSONString const&) -> bool;
  struct Hash { auto operator()(JSONString const&) const -> std::size_t; };
};

auto operator<<(std::ostream&, JSONString const&) -> std::ostream&;

/*
  JSON object type
*/

class JSONValue;

class JSONObject
{
  std::unordered_multimap<JSONString, JSONValue, JSONString::Hash> mappings;
  friend auto operator<<(std::ostream&, JSONObject const&) -> std::ostream& ;
public:
  explicit JSONObject() = default;
  explicit JSONObject(JSONString&&, JSONValue&&);
  auto emplace(JSONString&&, JSONValue&&) -> void;
  auto at(JSONString const&) const -> JSONValue const&;
};

auto operator<<(std::ostream&, JSONObject const&) -> std::ostream&;

/*
  JSON array type
*/

class JSONValue;

class JSONArray
{
  std::vector<JSONValue> elements;
  friend auto operator<<(std::ostream&, JSONArray const&) -> std::ostream&;
public:
  using size_type = decltype(elements)::size_type;
  explicit JSONArray() = default;
  explicit JSONArray(JSONValue&&);
  auto push_back(JSONValue&&) -> void;
  auto empty() const -> bool;
  auto size() const -> size_type;
  auto at(size_type index) const -> JSONValue const&;
};

auto operator<<(std::ostream&, JSONArray const&) -> std::ostream&;

/*
  JSON value type
*/

class JSONValue
{
  using value_type =
    std::variant<JSONNull, JSONBoolean, JSONNumber, JSONString,
                 JSONObject, JSONArray>;
  value_type v = JSON_NULL;
  friend auto operator<<(std::ostream&, JSONValue const&) -> std::ostream&;
public:
  auto operator=(JSONNull    ) -> JSONValue& ;
  auto operator=(JSONBoolean ) -> JSONValue& ;
  auto operator=(JSONNumber&&) -> JSONValue& ;
  auto operator=(JSONString&&) -> JSONValue& ;
  auto operator=(JSONObject&&) -> JSONValue& ;
  auto operator=(JSONArray &&) -> JSONValue& ;
};

auto operator<<(std::ostream&, JSONValue const&) -> std::ostream&;

/* End of file */
