# encoding: utf-8

require 'spec_helper'

module Rubocop
  module Cop
    module Lint
      describe RescueException do
        subject(:cop) { described_class.new }

        it 'registers an offence for rescue from Exception' do
          inspect_source(cop,
                         ['begin',
                          '  something',
                          'rescue Exception',
                          '  #do nothing',
                          'end'])
          expect(cop.offences.size).to eq(1)
          expect(cop.messages)
            .to eq(['Avoid rescuing the Exception class.'])
        end

        it 'registers an offence for rescue with ::Exception' do
          inspect_source(cop,
                         ['begin',
                          '  something',
                          'rescue ::Exception',
                          '  #do nothing',
                          'end'])
          expect(cop.offences.size).to eq(1)
          expect(cop.messages)
            .to eq(['Avoid rescuing the Exception class.'])
        end

        it 'registers an offence for rescue with StandardError, Exception' do
          inspect_source(cop,
                         ['begin',
                          '  something',
                          'rescue StandardError, Exception',
                          '  #do nothing',
                          'end'])
          expect(cop.offences.size).to eq(1)
          expect(cop.messages)
            .to eq(['Avoid rescuing the Exception class.'])
        end

        it 'registers an offence for rescue with Exception => e' do
          inspect_source(cop,
                         ['begin',
                          '  something',
                          'rescue Exception => e',
                          '  #do nothing',
                          'end'])
          expect(cop.offences.size).to eq(1)
          expect(cop.messages)
            .to eq(['Avoid rescuing the Exception class.'])
        end

        it 'does not register an offence for rescue with no class' do
          inspect_source(cop,
                         ['begin',
                          '  something',
                          '  return',
                          'rescue',
                          '  file.close',
                          'end'])
          expect(cop.offences).to be_empty
        end

        it 'does not register an offence for rescue with no class and => e' do
          inspect_source(cop,
                         ['begin',
                          '  something',
                          '  return',
                          'rescue => e',
                          '  file.close',
                          'end'])
          expect(cop.offences).to be_empty
        end

        it 'does not register an offence for rescue with other class' do
          inspect_source(cop,
                         ['begin',
                          '  something',
                          '  return',
                          'rescue ArgumentError => e',
                          '  file.close',
                          'end'])
          expect(cop.offences).to be_empty
        end

        it 'does not register an offence for rescue with other classes' do
          inspect_source(cop,
                         ['begin',
                          '  something',
                          '  return',
                          'rescue EOFError, ArgumentError => e',
                          '  file.close',
                          'end'])
          expect(cop.offences).to be_empty
        end

        it 'does not register an offence for rescue with a module prefix' do
          inspect_source(cop,
                         ['begin',
                          '  something',
                          '  return',
                          'rescue Test::Exception => e',
                          '  file.close',
                          'end'])
          expect(cop.offences).to be_empty
        end

        it 'does not crash when the splat operator is used in a rescue' do
          inspect_source(cop,
                         ['ERRORS = [Exception]',
                          'begin',
                          '  a = 3 / 0',
                          'rescue *ERRORS',
                          '  puts e',
                          'end'])
          expect(cop.offences).to be_empty
        end
      end
    end
  end
end
