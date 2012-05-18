class ReportMarkerGUI < ReportMarker

	include GladeGUI

	def initialize
		@r1 = @r2 = false
    @a1 = @a2 = @a3 = @a4 = @a5 =@a5_2 = @a6 = @a6_2 = false
    @a7 = @a7_2 = false
    @s1 = @s2 = @s3 = false
    @d1 = @d2 = @d2_2 = @d3 = @d3_2 = @d4 = @d4_2 = @d5 = false
    @d5_2 = @d5_3 = @d6 = @d6_2 = @d7 = @d7_2 = false
    @d8 = @d8_2 = @d8_3 = @d9 = @d9_2 = @d9_3 = @d10 = false
    @d10_2 = @d10_3 = @d11 = @d11_2 = false
    @marker_name = nil
    @student_number = "Y"
	end

	def show()
		load_glade(__FILE__)  #loads file, glade/ReportMarkerGUI.glade into @builder
		set_glade_all(self) #populates glade controls with instance variables (i.e. Myclass.var1)
    
		show_window()
	end
  
	def buttonSave__clicked(button)
		get_glade_all() # get values of controls
  
    if all_details_present?
      case @builder["notepad_parts"].page
      when 0
        if File.exists?(ReportMarker.marking_form_output_filename(@student_number))
          if VR::Dialog.ok_box("You've already completed part one for this student, continuing will overwrite it.", title = "Marking Assistant")
            ReportMarker.generate_part_one(@marker_name, @student_number, part_one_marks)
          end
        else
          ReportMarker.generate_part_one(@marker_name, @student_number, part_one_marks)
        end
      when 1
p        testing_and_verification_checkboxes
=begin
if File.exists?(ReportMarker.marking_form_output_filename(@student_number))
          if VR::Dialog.ok_box("You've already completed some of the marking for this student, continuing will overwrite part two.", title = "Marking Assistant")
            #ReportMarker.generate_part_two(part_two_details)
          end
        else
          #ReportMarker.generate_part_two(part_two_details)
        end
=end
      end
    end
	end
  
  def part_one_marks
    marks = {:requirements => requirements_totalled,
      :analysis => analysis_totalled,
      :specification => specification_totalled,
      :design => design_totalled,
    }
  end
  
  def part_two_details
    details = {:implementation => implementation_totalled,
      :code_listing => coding_listing_totalled,
      :testing_and_verification => testing_and_verification_totalled,
      :user_manual => user_manual_totalled,
      :mcpi => mcpi_totalled,
      #:input_filename => ,
      #:output_filename =>
    }
  end
  
  def implementation_checkboxes
    implementation = Array.new
    1.upto(3) do |checkbox_number|
      if @builder["checkbutton_i#{checkbox_number}"].active?
        implementation << 1
      else
        implementation << 0
      end
    end
    implementation
  end
  
  def code_listing_checkboxes
    code_listing = Array.new
    1.upto(11) do |checkbox_number|
      if @builder["checkbutton_cl#{checkbox_number}"].active?
        code_listing << 1
      else
        code_listing << 0
      end
    end
    
    1.upto(11) do |checkbox_number|
      unless @builder["checkbutton_cl#{checkbox_number}_2"].nil?
        if @builder["checkbutton_cl#{checkbox_number}_2"].active?
          code_listing[checkbox_number-1] += 1
        end
      end
      unless @builder["checkbutton_cl#{checkbox_number}_3"].nil?
        if @builder["checkbutton_cl#{checkbox_number}_3"].active?
          code_listing[checkbox_number-1] += 1
        end
      end
    end
    code_listing
  end
  
  def testing_and_verification_checkboxes
    testing_and_verification = Array.new
    1.upto(5) do |checkbox_number|
      if @builder["checkbutton_tv#{checkbox_number}"].active?
        testing_and_verification << 1
      else
        testing_and_verification << 0
      end
    end
    testing_and_verification
  end
  
  def user_manual_totalled
    1
  end
  
  def mcpi_totalled
    1
  end
  
  
  
  
  def show_validation_problems
    if @marker_name.empty?
      VR::Dialog.message_box("You forgot to fill in your name! Please put it in the box at the top.", title = "Marking Assistant")
    end
    if @student_number.length < 2
      VR::Dialog.message_box("Did you forget to fill in the student number? It should be more than 2 characters long.", title = "Marking Assistant")
    end
  end
  
  def all_details_present?
    if answer = (@marker_name.empty? || @student_number.length < 2)
      show_validation_problems
    end
    !answer
  end
  
  def requirements_totalled
    requirements_combined = Array.new
    requirements_checkboxes.each do |got_mark|
      if got_mark
        requirements_combined << 1
      else
        requirements_combined << 0
      end
    end
    requirements_combined
  end
  
  def analysis_totalled
    analysis_combined = Array.new
    analysis_checkboxes.each_with_index do |got_mark, index|
      case index
      when 0..4, 6, 8 # when is a question
        if got_mark
          analysis_combined << 1  # add entry to array
        else
          analysis_combined << 0
        end
      else # increment current question total
        if got_mark
          analysis_combined[analysis_combined.length-1] = analysis_combined.last + 1
        end
      end
    end
    analysis_combined
  end
  
  def specification_totalled
    specification_combined = Array.new
    specification_checkboxes.each do |got_mark|
      if got_mark
        specification_combined << 1
      else
        specification_combined << 0
      end
    end
    specification_combined
  end
  
  def design_totalled
    design_combined = Array.new
    design_checkboxes.each_with_index do |got_mark, index|
      case index
      when 0, 1, 3, 5, 7, 10, 12, 14, 17, 20, 23 # when is a question
        if got_mark
          design_combined << 1 # add entry to array
        else
          design_combined << 0
        end
      else # increment current question total
        if got_mark
          design_combined[design_combined.length-1] = design_combined.last + 1
        end
      end
    end
    design_combined
  end
  
  def requirements_checkboxes
    requirements = Array.new
    requirements << @r1 << @r2
  end
  
  def analysis_checkboxes
    analysis = Array.new
    analysis << @a1 << @a2 << @a3 << @a4 << @a5 << @a5_2 <<
      @a6 << @a6_2 << @a7 << @a7_2
  end
  
  def specification_checkboxes
    specification = Array.new
    specification << @s1 << @s2 << @s3
  end
  
  def design_checkboxes
    design = Array.new
    design << @d1 << @d2 << @d2_2 << @d3 << @d3_2 << @d4 <<
      @d4_2 << @d5 << @d5_2 << @d5_3 << @d6 << @d6_2 << @d7 <<
      @d7_2 << @d8 << @d8_2 << @d8_3 << @d9 << @d9_2 <<
      @d9_3 << @d10 << @d10_2 << @d10_3 << @d11 << @d11_2
  end

end
