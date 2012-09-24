module RailsI18nRecord
  module ActiveRecord
    module NonTranslatableMethods
      
      def translatable?
        @translatable == true
      end
      
      def translatable_attrs
        @translatable_atrrs ||= []
      end
    
      def attr_translatable(*args)
        unless translatable?    
          send :include, RailsI18nRecord::ActiveRecord::TranslatableMethods
          default_scope :include => :translation
          has_one :translation, :class_name => translation_class, :autosave => true, :dependent => :destroy, :conditions => {:locale => I18n.locale}
          has_many :translations, :class_name => translation_class, :autosave => true, :dependent => :destroy                 
          after_create :late_translations
          after_save :late_translations                      
          @translatable_atrrs = []               
          @translatable = true      
        end
        args.each do |arg|
          @translatable_atrrs << arg
          define_method "#{arg}=" do |value|     
            t = current_locale == I18n.locale ? translation : translations.find_by_locale(current_locale)
            t ? t.send("#{arg}=".to_sym, value) : translate_late(current_locale, arg.to_sym => value)        
          end        
          define_method "#{arg}" do
            t = current_locale == I18n.locale ? translation : translations.find_by_locale(current_locale)
            t ? t.send(arg.to_sym) : ''      
          end                 
        end         
      end  
      
      def translation_class
        "#{name}Translation"
      end
    
      def translation_fk
        "#{table_name.singularize}_id"
      end      
      
    end    
    module TranslatableMethods
      
      def with_locale(locale)
        @locale = locale
      end
      
      def build_translation
        super :locale => I18n.locale
      end
      
      def build_translations
        I18n.available_locales.each do |locale| 
          t = translations.find_by_locale(locale)
          translations.build :locale => locale.to_s unless t
        end
      end      
      
      protected
      
      def current_locale
        defined?(@locale) ? @locale : I18n.locale
      end

      def late_translations
        if @translate_late.is_a?(Hash)
          @translate_late.each do |locale, params|
            t = current_locale == I18n.locale ? translation : translations.find_by_locale(current_locale)
            t ? t.update_attributes(params) : translations.create(params.merge(:locale => locale.to_s))
          end
          @translate_late.clear
        end
      end    

      def translate_late(locale, fields)
        if @translate_late.is_a?(Hash)
          if @translate_late[locale].is_a?(Hash)
            @translate_late[locale].merge! fields
          else
            @translate_late[locale] = fields
          end        
        else
          @translate_late = {locale => fields}        
        end
      end
      
    end
  end
end

ActiveRecord::Base.send :extend, RailsI18nRecord::ActiveRecord::NonTranslatableMethods