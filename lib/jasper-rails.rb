#
# Copyright (C) 2012 Marlus Saraiva, Rodrigo Maia
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require "jasper-rails/version"
require "rails"
require "rjb"
require "action_controller/metal/responder"

if Mime::Type.lookup_by_extension("pdf").nil?
  Mime::Type.register "application/pdf", :pdf
end

module JasperRails

  class << self
    attr_accessor :config
  end

 #classpath = '.'
 #Dir["#{File.dirname(__FILE__)}/java/*.jar"].each do |jar|
 #  classpath << File::PATH_SEPARATOR + File.expand_path(jar)
 #end

 #Dir["lib/*.jar"].each do |jar|
 #  classpath << File::PATH_SEPARATOR + File.expand_path(jar)
 #end

 #if Rails.env.development?
 #  Rjb::load( classpath, ['-Djava.awt.headless=true', '-Djdbc.drivers=org.sqlite.JDBC','-Xms128M', '-Xmx256M'] ) unless Rjb::loaded?
 #end
 #if Rails.env.production?
 #  # Hack for Amazon Linux
 #  #ENV['JAVA_HOME'] = "/usr/lib/jvm/java"
 #  #ENV['LD_LIBRARY_PATH'] = "/usr/lib:/usr/lib/jvm/java/jre/lib/amd64:/usr/lib/jvm/java/jre/lib/amd64/server"
 #  Rjb::load( classpath, ['-Djava.awt.headless=true', '-Djdbc.drivers=com.mysql.jdbc.Driver','-Xms128M', '-Xmx256M'] ) unless Rjb::loaded?
 #end


 #Locale                      = Rjb::import 'java.util.Locale'
 #JRException                 = Rjb::import 'net.sf.jasperreports.engine.JRException'
 #JasperCompileManager        = Rjb::import 'net.sf.jasperreports.engine.JasperCompileManager'
 #JasperExportManager         = Rjb::import 'net.sf.jasperreports.engine.JasperExportManager'
 #JasperFillManager           = Rjb::import 'net.sf.jasperreports.engine.JasperFillManager'
 #JasperPrint                 = Rjb::import 'net.sf.jasperreports.engine.JasperPrint'
 #JRXmlUtils                  = Rjb::import 'net.sf.jasperreports.engine.util.JRXmlUtils'
 #JREmptyDataSource           = Rjb::import 'net.sf.jasperreports.engine.JREmptyDataSource'
 ## This is here to avoid the "already initialized constant QUERY_EXECUTER_FACTORY_PREFIX" warnings.
 #JRXPathQueryExecuterFactory = silence_warnings{Rjb::import 'net.sf.jasperreports.engine.query.JRXPathQueryExecuterFactory'}
 #InputSource                 = Rjb::import 'org.xml.sax.InputSource'
 #StringReader                = Rjb::import 'java.io.StringReader'
 #HashMap                     = Rjb::import 'java.util.HashMap'
 #ByteArrayInputStream        = Rjb::import 'java.io.ByteArrayInputStream'
 #JavaString                  = Rjb::import 'java.lang.String'
 #JFreeChart                  = Rjb::import 'org.jfree.chart.JFreeChart'
 ## SQL Connections
 #JavaSystem                  = Rjb::import 'java.lang.System'
 #DriverManager               = Rjb::import 'java.sql.DriverManager'
 #SQLException                = Rjb::import 'java.sql.SQLException'

 #if Rails.env.development?
 #  connection                  = DriverManager.getConnection("jdbc:sqlite:/Users/obrientimothya/Dropbox/development/vle/db/development.sqlite3")
 #end
 #if Rails.env.production?
 #  connection                  = DriverManager.getConnection("jdbc:mysql://#{ENV['RDS_HOSTNAME']}:#{ENV['RDS_PORT']}/#{ENV['RDS_DB_NAME']}", ENV['RDS_USERNAME'], ENV['RDS_PASSWORD'])
 #end


  # Default report params
 #self.config = {
 #  :report_params=>{
 #    "REPORT_LOCALE"    => Locale.new('en', 'US'),
 #    "XML_LOCALE"       => Locale.new('en', 'US'),
 #    "XML_DATE_PATTERN" => 'yyyy-MM-dd'
 #  }
 #}

  module Jasper
    module Rails
      
      def self.classpath
        classpaths = '.'
        Dir["#{File.dirname(__FILE__)}/java/*.jar"].each do |jar|
          classpaths << File::PATH_SEPARATOR + File.expand_path(jar)
        end

        Dir["lib/*.jar"].each do |jar|
          classpaths << File::PATH_SEPARATOR + File.expand_path(jar)
        end
        classpaths
      end

      def self.render_pdf(jasper_file, datasource, parameters, options)

        if Rails.env.development?
          Rjb::load( classpath, ['-Djava.awt.headless=true', '-Djdbc.drivers=org.sqlite.JDBC','-Xms128M', '-Xmx256M'] ) unless Rjb::loaded?
        end
        if Rails.env.production?
          # Hack for Amazon Linux
          #ENV['JAVA_HOME'] = "/usr/lib/jvm/java"
          #ENV['LD_LIBRARY_PATH'] = "/usr/lib:/usr/lib/jvm/java/jre/lib/amd64:/usr/lib/jvm/java/jre/lib/amd64/server"
          Rjb::load( classpath, ['-Djava.awt.headless=true', '-Djdbc.drivers=com.mysql.jdbc.Driver','-Xms128M', '-Xmx256M'] ) unless Rjb::loaded?
        end


        # The code below is to workaround declaring constants within methods
        # We would like to delay these till a request is received to workaround Apache Passenger issue
        locale                      = Rjb::import 'java.util.Locale'
        jRException                 = Rjb::import 'net.sf.jasperreports.engine.JRException'
        jasperCompileManager        = Rjb::import 'net.sf.jasperreports.engine.JasperCompileManager'
        jasperExportManager         = Rjb::import 'net.sf.jasperreports.engine.JasperExportManager'
        jasperFillManager           = Rjb::import 'net.sf.jasperreports.engine.JasperFillManager'
        jasperPrint                 = Rjb::import 'net.sf.jasperreports.engine.JasperPrint'
        jRXmlUtils                  = Rjb::import 'net.sf.jasperreports.engine.util.JRXmlUtils'
        jREmptyDataSource           = Rjb::import 'net.sf.jasperreports.engine.JREmptyDataSource'
        jRXPathQueryExecuterFactory = silence_warnings{Rjb::import 'net.sf.jasperreports.engine.query.JRXPathQueryExecuterFactory'}
        inputSource                 = Rjb::import 'org.xml.sax.InputSource'
        stringReader                = Rjb::import 'java.io.StringReader'
        hashMap                     = Rjb::import 'java.util.HashMap'
        byteArrayInputStream        = Rjb::import 'java.io.ByteArrayInputStream'
        javaString                  = Rjb::import 'java.lang.String'
        jFreeChart                  = Rjb::import 'org.jfree.chart.JFreeChart'
        javaSystem                  = Rjb::import 'java.lang.System'
        driverManager               = Rjb::import 'java.sql.DriverManager'
        sqlException                = Rjb::import 'java.sql.SQLException'
        if Rails.env.development?
          connection                = DriverManager.getConnection("jdbc:sqlite:/Users/obrientimothya/Dropbox/development/vle/db/development.sqlite3")
        end
        if Rails.env.production?
          connection                = DriverManager.getConnection("jdbc:mysql://#{ENV['RDS_HOSTNAME']}:#{ENV['RDS_PORT']}/#{ENV['RDS_DB_NAME']}", ENV['RDS_USERNAME'], ENV['RDS_PASSWORD'])
        end


        options ||= {}
        parameters ||= {}
        jrxml_file  = jasper_file.sub(/\.jasper$/, ".jrxml")

        begin

          # Default report params
          config = {
            :report_params=>{
              "REPORT_LOCALE"    => Locale.new('en', 'US'),
              "XML_LOCALE"       => Locale.new('en', 'US'),
              "XML_DATE_PATTERN" => 'yyyy-MM-dd'
            }
          }

          # Converting default report params to java HashMap
          jasper_params = hashMap.new
          config[:report_params].each do |k,v|
            jasper_params.put(k, v)
          end

          # Convert the ruby parameters' hash to a java HashMap, but keeps it as
          # default when they already represent a JRB entity.
          # Pay attention that, for now, all other parameters are converted to string!
          parameters.each do |key, value|
            jasper_params.put(javaString.new(key.to_s), parameter_value_of(value))
          end

          # Compile it, if needed
          if !File.exist?(jasper_file) || (File.exist?(jrxml_file) && File.mtime(jrxml_file) > File.mtime(jasper_file))
            jasperCompileManager.compileReportToFile(jrxml_file, jasper_file)
          end

          # Fill the report
          #if datasource
          #  input_source = InputSource.new
          #  input_source.setCharacterStream(StringReader.new(datasource.to_xml(options).to_s))
          #  data_document = silence_warnings do
          #    # This is here to avoid the "already initialized constant DOCUMENT_POSITION_*" warnings.
          #    JRXmlUtils._invoke('parse', 'Lorg.xml.sax.InputSource;', input_source)
          #  end

          #  jasper_params.put(JRXPathQueryExecuterFactory.PARAMETER_XML_DATA_DOCUMENT, data_document)
          #  jasper_print = JasperFillManager.fillReport(jasper_file, jasper_params)
          #else
          #  jasper_print = JasperFillManager.fillReport(jasper_file, jasper_params, JREmptyDataSource.new)
          #end
          #
          jasper_print = JasperFillManager.fillReport(jasper_file, jasper_params, connection)

          # Export it!
          jasperExportManager._invoke('exportReportToPdf', 'Lnet.sf.jasperreports.engine.JasperPrint;', jasper_print)
        rescue Exception=>e
          if e.respond_to? 'printStackTrace'
            ::Rails.logger.error e.message
            e.printStackTrace
          else
            ::Rails.logger.error e.message + "\n " + e.backtrace.join("\n ")
          end
          raise e
        end
      end

      # Returns the value without conversion when it's converted to Java Types.
      # When isn't a Rjb class, returns a Java String of it.
      def self.parameter_value_of(param)
        javaString                  = Rjb::import 'java.lang.String'
        # Using Rjb::import('java.util.HashMap').new, it returns an instance of
        # Rjb::Rjb_JavaProxy, so the Rjb_JavaProxy parent is the Rjb module itself.
        if param.class.parent == Rjb
          param
        else
          javaString.new(param.to_s)
        end
      end
    end
  end

  class ActionController::Responder
    def to_pdf
      #jasper_file = "#{Rails.root.to_s}/app/views/#{controller.controller_path}/#{controller.action_name}.jasper"
      jasper_file =  (@options[:template] && "#{Rails.root.to_s}/app/views/#{controller.controller_path}/#{@options[:template]}") ||
          "#{Rails.root.to_s}/app/views/#{controller.controller_path}/#{controller.action_name}.jasper"

      params = {}
      controller.instance_variables.each do |v|
        params[v.to_s[1..-1]] = controller.instance_variable_get(v)
      end

      #controller.send_data Jasper::Rails::render_pdf(jasper_file, resource, params, options), :type => Mime::PDF
      controller.send_data Jasper::Rails::render_pdf(jasper_file, resource, params, options), :type => Mime::PDF, :disposition => 'inline'
    end
  end

end
