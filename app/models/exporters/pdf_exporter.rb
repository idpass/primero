require 'prawn/document'

module Exporters
  class PDFExporter < BaseExporter
    class << self
      def id
        'case_pdf'
      end

      def mime_type
        'pdf'
      end

      def supported_models
        [Child]
      end

      def export(cases, _, current_user)
        pdf = Prawn::Document.new(:info => {
          :Title => "Primero Child Export",
          :Author => "Primero",
          :Subject => "Ids: " + (cases.map {|c| c.case_id}.join(', ')),
          :CreationDate => Time.now,
        })

        form_sections = form_sections_by_module(cases, current_user)

        cases.each do |c|
          pdf.start_new_page if pdf.page_number > 1
          pdf.outline.section(section_title(c), :destination => pdf.page_number)
          render_case(pdf, c, form_sections[c.module.name])
        end

        pdf.render
      end

      def form_sections_by_module(cases, current_user)
        cases.map(&:module).compact.uniq.inject({}) do |acc, mod|
          acc.merge({mod.name => FormSection.get_permitted_form_sections(mod, 'case', current_user)
                                       .select(&:visible)
                                       .sort {|a, b| [a.order_form_group, a.order] <=> [b.order_form_group, b.order] } })
        end
      end

      def section_title(_case)
        (!_case.hidden_name && _case.name) || _case.short_id
      end

      def render_case(pdf, _case, base_subforms)
        render_title(pdf, _case)

        render_photo(pdf, _case)

        grouped_subforms = base_subforms.group_by(&:form_group_name)

        pdf.outline.add_subsection_to(section_title(_case)) do
          grouped_subforms.each do |(parent_group, fss)|
            pdf.outline.section(parent_group, :destination => pdf.page_number, :closed => true) do
              fss.each do |fs|
                pdf.text fs.name, :style => :bold, :size => 16
                pdf.move_down 10

                pdf.outline.section(fs.name, :destination => pdf.page_number)

                render_form_section(pdf, _case, fs)

                pdf.move_down 10
              end
            end
          end
        end
      end

      def render_title(pdf, _case)
        pdf.text section_title(_case), :style => :bold, :size => 20, :align => :center
      end

      def render_photo(pdf, _case)
        photo_file = if _case.primary_photo
          _case.primary_photo.data
        else
          File.new("app/assets/images/no_photo_clip.jpg", 'r')
        end

        pdf.image(photo_file,
          :position => :center,
          :fit => [pdf.bounds.width, pdf.bounds.width])
      end

      def render_form_section(pdf, _case, form_section)
        (subforms, normal_fields) = form_section.fields.reject {|f| f.type == 'separator' }
                                                       .partition {|f| f.type == Field::SUBFORM }

        render_fields(pdf, _case, normal_fields)

        subforms.map do |subf|
          pdf.move_down 10

          form_data = _case.__send__(subf.name)
          if (form_data.try(:length) || 0) > 0
            pdf.text subf.display_name, :style => :bold, :size => 12
            form_data.each do |el|
              render_fields(pdf, el, subf.subform_section.fields.reject {|f| f.type == 'separator' })
              pdf.move_down 10
            end
          end
        end
      end

      def render_fields(pdf, obj, fields)
        table_data = fields.map do |f|
          value = censor_value(f.name, obj)
          [f.display_name, format_field(f, value)]
        end

        table_options = {
          :row_colors => %w[  cccccc ffffff  ],
          :width => 500,
          :column_widths => {0 => 200, 1 => 300},
          :position => :left,
        }

        pdf.table(table_data, table_options) if table_data.length > 0
      end

      def censor_value(attr_name, obj)
        case attr_name
        when 'name'
          obj.try(:hidden_name) ? '***hidden***' : obj.name
        else
          obj.__send__(attr_name)
        end
      end

      def format_field(field, value)
        case value
        when TrueClass, FalseClass
          value ? {:image => Rails.root.join("app/assets/images/icon-tick.png")} : ""
        when String
          value
        when DateTime
          value.strftime("%d-%b-%Y")
        when Date
          value.strftime("%d-%b-%Y")
        when Array
          value.map {|el| format_field(field, el) }.join(', ')
        #when Hash
          #value.inject {|acc, (k,v)| acc.merge({ k => format_field(field, v) }) }
        else
          value.to_s
        end
      end
    end
  end
end