# frozen_string_literal: true

# Role Object for user
class HbxStaffRole
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :user

  field :is_active, type: Boolean, default: true
  field :subrole, type: String, default: ""
  field :permission_id, type: BSON::ObjectId

  accepts_nested_attributes_for :user

  def permission
    return nil if permission_id.blank?
    @permission ||= Permission.find(permission_id)
  end

  def self.find(id)
    return nil if id.blank?
    user = User.where("hbx_staff_role._id" => BSON::ObjectId.from_string(id)).first
    user&.hbx_staff_role
  end
end
