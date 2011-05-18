class User < ActiveRecord::Base
  include ActiveModel::Validations
  attr_writer :current_step

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable#, :if => lambda { |o| o.current_step == "user" }
  devise :registerable#, :if => lambda { |o| o.current_step == "user" }
  devise :recoverable#, :if => lambda { |o| o.current_step == "user" }
  devise :rememberable#, :if => lambda { |o| o.current_step == "user" }
  devise :trackable#, :if => lambda { |o| o.current_step == "user" }
  #after_save :get_prof

  with_options :on => :create, :if => lambda { |o| o.current_step == "user" } do |v|
    v.validates :email,  :presence => true,
      :uniqueness => true,
      :check_email => true
    #v.validates :username, :presence => true, :uniqueness => true
    v.validates :password, :presence => true,
      :confirmation => true,
      :length => { :minimum => 6, :maximum => 20, }
  end

  with_options :on => :update do |v|
    v.validates :email,
      :presence => true,
      :uniqueness => true,
      :check_email => true
    #v.validates :username, :presence => true, :uniqueness => true
    v.validates :password,
      :confirmation => true

  end

  with_options :on => :create do |v|
    v.validates :link, :presence => true,
      :uniqueness => true,
      :length => { :minimum => 1, :maximum => 9, },
      :format => { :with => /\A\d*\z/ },
      :exist => true
  end
  
  has_and_belongs_to_many :roles
  has_many :licences, :dependent => :delete_all
  has_many :posts, :dependent => :nullify
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role_ids, :link

  def current_step
    @current_step || steps.first
  end

  def steps
    %w[link user]
  end

  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end

  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end

  def first_step?
    current_step == steps.first
  end

  def last_step?
    current_step == steps.last
  end

  def all_valid?
    steps.all? do |step|
      self.current_step = step
      valid?
    end
  end

  
  def role? (role)
    return !!self.roles.find_by_name(role.to_s.camelize)
  end
  
  def get_user_name_from_link(link)
    page = get_user_page_from_link(link)
    nick = page.forms.first['nick']
    return nick
  end

  def get_user_page_from_link (link)
    agent = Mechanize.new
    page = agent.get("http://utes.apeha.ru/info.html?user=#{link}")
    page = agent.get(page.body.scan(/location.href=\"(.*\.html)/)[0][0]) if page.links.blank?
    return page
  end

  def get_prof
    page = get_user_page_from_link(self.link)
    town = page.uri.host.split(/\./)[0]
    unless town.include?("forest")
      links = page.search("a")
      profs = Hash.new { |hash, key| hash[key] = []}
      links.each { |l| profs[l.content] << l.attr(:href).to_s  unless l[:title].blank?}
      self.licences.find(:all, :conditions => "town='#{town}'").each do |l|
        if profs[l.name].blank?
          l.destroy
        else
          profs.delete (l.name)
        end
      end
#Iconv.conv('UTF-8', 'windows-1251', p)
      profs.keys.each {|p| self.licences.create (attributes = {"name"=> p, "town"=>town, "link"=>profs[p][0]})}
    end
  end
end