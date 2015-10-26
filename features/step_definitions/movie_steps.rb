# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  Movie.delete_all
  movies_table.hashes.each do |movie|
     Movie.find_or_create_by movie
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
    uncheck "ratings_G" #manually unchecking...shouldn't do this
    uncheck "ratings_R"
    uncheck "ratings_PG-13"
    uncheck "ratings_NC-17"
    uncheck "ratings_PG"
    
    ratingArr=arg1.split(", ")
    ratingArr.each do |rating| #checking the appropriate buttons
        puts rating
        check "ratings_"+rating
    end
    click_button 'Refresh'
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
    #go through table
    result=true
    ratingArr=arg1.split(", ")
    all("tr").each do |tr|
        puts tr.text
    end

    all("tr").each do |tr| #pretty bad way of testing this, but I don't how to do union of contents
        if result==false
            break
        end
        ratingArr.each do |rating|
           if tr.has_content?(rating)
               result=true
               break
            else
                result=false
            end
        end
    end  
    expect(result).to be_truthy
end

Then /^I should see all of the movies$/ do
    result=false
    row_count=0
     all("tr").each do |tr|
        row_count+=1
     end
     puts "row_count "+ row_count.to_s
     puts "movie_count "+ Movie.count.to_s
     if Movie.count == row_count-1 #get rid of the title row
         result=true
     else
         result=false
     end
    expect(result).to be_truthy
end

When /^I have sorted movies by Movie Title$/ do
    click_on "Movie Title"
    #Movies.order("lower(title) ASC").all #sort database
end

When /^I have sorted movies by Release Date$/ do 
    click_on "Release Date"
    #Movies.order("release_date ASC").all
end

Then /^I should see "(.*?)" before "(.*?)"$/ do |title1, title2|
    result=false
    prev_count=0
    count=0
    all("tr").each do |tr|
        count+=1
      if  tr.has_content?(title1) 
          prev_count=count 
      elsif tr.has_content?(title2) && count==prev_count+1
        result=true
      end
    end
    expect(result).to be_truthy
end


