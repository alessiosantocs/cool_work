class PhrasesUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :phrase
end

class RType < PhrasesUser; end

class Interest < PhrasesUser; end

class TurnOn < PhrasesUser; end

class TurnOff < PhrasesUser; end