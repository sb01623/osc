#!/bin/env ruby
# encoding: utf-8
#07-2013 Migration in Ruby On Rails  3.2 by Benjamin Ninassi
class Refu < ActiveRecord::Base
  belongs_to :contrat
  validates_date          :date, :message => "La date doit être valide"
  validates_uniqueness_of :contrat_id  
  
  before_update 'self.updated_by = User.current_user.id'
  before_create 'self.created_by = User.current_user.id',
                'self.updated_by = User.current_user.id'
  
  after_create :up_contrat_etat
  after_destroy :down_contrat_etat              
  
  attr_accessible :date, :liste_attente, :labelise, :commentaire
  
  def up_contrat_etat
    update_contrat_etat("refus")  
  end
  
  def down_contrat_etat
    update_contrat_etat("soumission")
  end
  
  def update_contrat_etat(nouvel_etat)
    c = self.contrat
    c.etat = nouvel_etat
    c.save
  end
  
end
