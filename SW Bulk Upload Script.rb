require 'csv'
require 'selenium-webdriver'

# Prompt user for CSV file path
puts "Please enter the path to your CSV file:"
csv_path = gets.chomp
csv_path = csv_path.gsub(/\"/, '') # Remove double quotes from the path

# Extract email addresses and passwords from the CSV
emails_passwords = []
CSV.foreach(csv_path, headers: true) do |row|
  emails_passwords << { email: row['EmailAddress'], password: row['Password'] }
end

puts "Number of email addresses in the CSV: #{emails_passwords.length}"

# Ask for confirmation
loop do
  print "Do you want to continue with the process? (y/n): "
  response = gets.chomp.downcase

  case response
  when 'y'
    break
  when 'n'
    exit
  else
    puts "Wrong input! Please try again."
  end
end

# Prompt user for custom Microsoft login page URL
print "Please enter the custom Microsoft login page URL: "
custom_login_url = gets.chomp

begin
  emails_passwords.each do |record|
    email = record[:email]
    password = record[:password]

    driver = Selenium::WebDriver.for :chrome
    driver.navigate.to custom_login_url

    sleep 5

    oauth_username = email
    oauth_username_field = driver.find_element(name: 'loginfmt')
    oauth_username_field.send_keys(oauth_username)
    usnme_button = driver.find_element(css: 'input[type="submit"]')
    usnme_button.click

    sleep 5

    oauth_password = password
    oauth_password_field = driver.find_element(name: 'passwd')
    oauth_password_field.send_keys(oauth_password)
    pss_button = driver.find_element(css: 'input[type="submit"]')
    pss_button.click

    sleep 5

    accept_submit = driver.find_element(css: 'input[type="submit"]')
    accept_submit.click

    driver.quit
  end
rescue => exception
  p exception
end