require "rack/openid"

module OpenID
  module SReg
    DATA_FIELDS.merge!({
      "r61globalkey" => "No description",
      "r61studentid" => "No description",
      "staff" => "No description",
      "student" => "No description"
    })
  end
end
