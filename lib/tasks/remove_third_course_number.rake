desc "Remove the third course number to combine classes that are the same"
task :remove_third_course_number => :environment do
  Bundler.require(:progressbar)
  titles = {}
  progressbar = ProgressBar.create(:format => '%t |%b>%i| %p%% %a', :title => "Building Hash", :total => Title.count)
  Title.all.each do |t|
    title = "#{t.subject} #{t.course_num_2} #{t.name}"
    titles[title.to_sym] = [] if titles[title.to_sym].nil?
    titles[title.to_sym] << t.id
    progressbar.progress += 1
  end

  progressbar = ProgressBar.create(:format => '%t |%b>%i| %p%% %a', :title => "Reassigning Titles", :total => titles.keys.count)
  titles.keys.each do |key|
    if titles[key].count > 1
      master_id = titles[key].slice! 0
      Title.find(titles[key]).each do |t|
        Section.where(title_id: t).each do |s|
          s.update_attributes!(title_id: master_id)
        end
        Title.find(t).delete
      end
    end
    progressbar.progress += 1
  end

  Title.all.each do |t|
    t.update_attributes!(title: "#{t.course_num_2} #{t.name}")
  end
end