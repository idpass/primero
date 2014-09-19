
# Create enough cases to make a second page in the index view
filler_cases = (0..25).inject({}) do |acc, i|
  acc.merge({("ff928802-455b-4735-9e5c-4ed9acace1%.2d" % i) => ->(c) do
    c.name = "Child #{i}"
    c.created_at = DateTime.new(2014, 01, 01)
    c.module_id = 'primeromodule-cp'
  end})
end

{
  "ff928802-455b-4735-9e5c-4ed9acace001" => ->(c) do
    c.module_id = 'primeromodule-cp'
    c.name = 'David Thomas'
    c.hidden_name = true
    c.family_details_section = [
      {:relation_name => 'Jacob', :relation => 'Father'},
      {:relation_name => 'Martha', :relation => 'Mother'},
    ]
    c.date_of_birth = Date.new(2005, 01, 01)
    c.sex = 'Male'
    c.address_is_permanent = true
    c.address_current = '1 Arid Way'
  end,

  "ef928802-455b-4735-9e5c-4ed9acace002" => ->(c) do
    c.name = 'Jonah Jacobson'
    c.module_id = 'primeromodule-cp'
    c.sex = 'Male'
    c.religion = ['Religion1']
    c.ethnicity = ['Kenyan']
    c.address_is_permanent = true
    c.address_current = '123 Main St'
  end,

  "df928802-455b-4735-9e5c-4ed9acace003" => ->(c) do
    c.module_id = 'primeromodule-gbv'
    c.name = 'Mary Davidson'
    c.sex = 'Female'
  end,

}.merge(filler_cases).each do |k, v|
  default_owner = User.find_by_user_name("primero")
  c = Child.find_by_unique_identifier(k) || Child.new_with_user_name(default_owner, {:unique_identifier => k})
  v.call(c)
  puts "Child #{c.new? ? 'created' : 'updated'}: #{c.unique_identifier}"
  c.save!
end
