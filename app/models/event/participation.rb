# == Schema Information
#
# Table name: event_participations
#
#  id                     :integer          not null, primary key
#  event_id               :integer          not null
#  person_id              :integer          not null
#  additional_information :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  active                 :boolean          default(FALSE), not null
#  application_id         :integer
#

class Event::Participation < ActiveRecord::Base
  
  self.demodulized_route_keys = true
  
  attr_accessible :additional_information, :answers_attributes, :application_attributes
  
  
  ### ASSOCIATIONS
  
  belongs_to :event
  belongs_to :person
  
  has_many :roles, dependent: :destroy

  has_many :answers, dependent: :destroy, validate: true

  belongs_to :application, dependent: :destroy, validate: true
  
  
  accepts_nested_attributes_for :answers, :application
  
  
  ### VALIDATIONS
  
  validates :person_id, uniqueness: {scope: :event_id}
  
  
  ### CALLBACKS
  
  before_validation :set_self_in_nested


  def init_answers
    if answers.blank?
      event.questions.each do |q|
        self.answers << q.answers.new
      end
    end
  end
  
  ### INSTANCE METHODS
    
  
  private
  
  def set_self_in_nested
    # don't try to set self in frozen nested attributes (-> marked for destroy)
    answers.each {|e| e.participation = self unless e.frozen? }
  end

end