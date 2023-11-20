classdef ProyectoEDO < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure           matlab.ui.Figure
        GridLayout         matlab.ui.container.GridLayout
        LeftPanel          matlab.ui.container.Panel
        iEditField         matlab.ui.control.NumericEditField
        iEditFieldLabel    matlab.ui.control.Label
        BEditField         matlab.ui.control.EditField
        BEditFieldLabel    matlab.ui.control.Label
        PlotButton         matlab.ui.control.Button
        I0EditField        matlab.ui.control.NumericEditField
        I0EditFieldLabel   matlab.ui.control.Label
        S0EditField        matlab.ui.control.NumericEditField
        S0EditFieldLabel   matlab.ui.control.Label
        YEditField_3       matlab.ui.control.NumericEditField
        YEditField_3Label  matlab.ui.control.Label
        RightPanel         matlab.ui.container.Panel
        AproximacindelmodeloSIRporelmetododiferenciasfinitasLabel  matlab.ui.control.Label
        UIAxes             matlab.ui.control.UIAxes
    end

    % Properties that correspond to apps with auto-reflow
    properties (Access = private)
        onePanelWidth = 576;
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: I0EditField
        function I0EditFieldValueChanged(app, event)
            value = app.I0EditField.Value;
            
        end

        % Button down function: UIAxes
        function UIAxesButtonDown(app, event)
            
        end

        % Button pushed function: PlotButton
        function PlotButtonPushed(app, event)
            cla(app.UIAxes);
            so = app.S0EditField.Value;
            io = app.I0EditField.Value;
            y =  app.YEditField_3.Value;
            b =  str2num(app.BEditField.Value);
            iteraciones = app.iEditField.Value;

            dt=1;

            s(1)=so;
            s(2)=so-io;
            
            i(1)=0;
            i(2)=io;
            
            r(1)=0;
            r(2)=0;
            
            n=s(1)+i(1)+r(1);
            
            x=[1:1:iteraciones];
            
            for j = 1 : length(b)
              for t = 3 : iteraciones
                s(t)=s(t-2) - 2*dt*b(j)*s(t-1)*i(t-1);
                s(t)=abs(s(t)+s(t-1))/2;
                i(t)=i(t-2) + 2*dt*b(j)*s(t-1)*i(t-1)-2*dt*y*i(t-1);
                i(t)=abs(i(t)+i(t-1))/2;
                r(t)=r(t-2) + 2*dt*y*i(t-1);
                r(t)=abs(r(t)+r(t-1))/2;
                n=s(t)+i(t)+r(t);
              end
              
              plot(app.UIAxes,x,s,'b');
              if length(b) ~= 1
                text(app.UIAxes,x(iteraciones*0.10),s(iteraciones*0.10),strcat("S",mat2str(j)),'FontSize',20);
              end

              hold(app.UIAxes,'on');
              plot(app.UIAxes, x,i,'r');
              if length(b) ~= 1
                  text(app.UIAxes, x(iteraciones*0.60),i(iteraciones*0.6),strcat("I",mat2str(j)),'FontSize',20);
              end

              hold(app.UIAxes,'on');
              plot(app.UIAxes, x,r,'g');
              if length(b) ~= 1
                  text(app.UIAxes,x(iteraciones*0.60),r(iteraciones*0.60),strcat("R",mat2str(j)),'FontSize',20);
              end
              hold(app.UIAxes,'on');
            end
            title(app.UIAxes,strcat("Propagación de la enfermedad para gamma = ",mat2str(y)," beta = ", mat2str(b)));
            legend(app.UIAxes,"S(t)","I(t)","R(t)")
            
        end

        % Changes arrangement of the app based on UIFigure width
        function updateAppLayout(app, event)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)
                % Change to a 2x1 grid
                app.GridLayout.RowHeight = {480, 480};
                app.GridLayout.ColumnWidth = {'1x'};
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 1;
            else
                % Change to a 1x2 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {201, '1x'};
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 2;
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 934 480];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {201, '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'on';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create YEditField_3Label
            app.YEditField_3Label = uilabel(app.LeftPanel);
            app.YEditField_3Label.HorizontalAlignment = 'right';
            app.YEditField_3Label.Position = [31 274 25 22];
            app.YEditField_3Label.Text = 'Y';

            % Create YEditField_3
            app.YEditField_3 = uieditfield(app.LeftPanel, 'numeric');
            app.YEditField_3.Position = [71 274 100 22];

            % Create S0EditFieldLabel
            app.S0EditFieldLabel = uilabel(app.LeftPanel);
            app.S0EditFieldLabel.HorizontalAlignment = 'right';
            app.S0EditFieldLabel.Position = [31 362 25 22];
            app.S0EditFieldLabel.Text = 'S0';

            % Create S0EditField
            app.S0EditField = uieditfield(app.LeftPanel, 'numeric');
            app.S0EditField.Position = [71 362 100 22];

            % Create I0EditFieldLabel
            app.I0EditFieldLabel = uilabel(app.LeftPanel);
            app.I0EditFieldLabel.HorizontalAlignment = 'right';
            app.I0EditFieldLabel.Position = [31 326 25 22];
            app.I0EditFieldLabel.Text = 'I0';

            % Create I0EditField
            app.I0EditField = uieditfield(app.LeftPanel, 'numeric');
            app.I0EditField.ValueChangedFcn = createCallbackFcn(app, @I0EditFieldValueChanged, true);
            app.I0EditField.Position = [71 326 100 22];

            % Create PlotButton
            app.PlotButton = uibutton(app.LeftPanel, 'push');
            app.PlotButton.ButtonPushedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
            app.PlotButton.Position = [51 72 100 23];
            app.PlotButton.Text = 'Plot';

            % Create BEditFieldLabel
            app.BEditFieldLabel = uilabel(app.LeftPanel);
            app.BEditFieldLabel.HorizontalAlignment = 'right';
            app.BEditFieldLabel.Position = [31 214 25 22];
            app.BEditFieldLabel.Text = 'B';

            % Create BEditField
            app.BEditField = uieditfield(app.LeftPanel, 'text');
            app.BEditField.Position = [71 214 100 22];

            % Create iEditFieldLabel
            app.iEditFieldLabel = uilabel(app.LeftPanel);
            app.iEditFieldLabel.HorizontalAlignment = 'right';
            app.iEditFieldLabel.Position = [31 152 25 22];
            app.iEditFieldLabel.Text = 'i';

            % Create iEditField
            app.iEditField = uieditfield(app.LeftPanel, 'numeric');
            app.iEditField.Position = [71 152 100 22];

            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 2;

            % Create UIAxes
            app.UIAxes = uiaxes(app.RightPanel);
            xlabel(app.UIAxes, 't')
            ylabel(app.UIAxes, 'población')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.ButtonDownFcn = createCallbackFcn(app, @UIAxesButtonDown, true);
            app.UIAxes.Position = [6 6 721 357];

            % Create AproximacindelmodeloSIRporelmetododiferenciasfinitasLabel
            app.AproximacindelmodeloSIRporelmetododiferenciasfinitasLabel = uilabel(app.RightPanel);
            app.AproximacindelmodeloSIRporelmetododiferenciasfinitasLabel.HorizontalAlignment = 'center';
            app.AproximacindelmodeloSIRporelmetododiferenciasfinitasLabel.WordWrap = 'on';
            app.AproximacindelmodeloSIRporelmetododiferenciasfinitasLabel.FontSize = 24;
            app.AproximacindelmodeloSIRporelmetododiferenciasfinitasLabel.FontWeight = 'bold';
            app.AproximacindelmodeloSIRporelmetododiferenciasfinitasLabel.Position = [63 362 626 118];
            app.AproximacindelmodeloSIRporelmetododiferenciasfinitasLabel.Text = 'Aproximación del modelo SIR por el metodo diferencias finitas';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ProyectoEDO

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end