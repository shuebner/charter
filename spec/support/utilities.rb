include ApplicationHelper

def page_ok(path, name, title, heading, text)
  StaticPage.create!(name: name, title: title, 
      heading: heading, text: text)  
  visit path

  it { should have_selector('title', text: title) }
  it { should have_selector('h1', text: heading) }
  it { should have_content(text) }
end