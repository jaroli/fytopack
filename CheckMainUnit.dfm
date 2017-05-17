object CheckMainForm: TCheckMainForm
  Left = 301
  Top = 174
  Width = 696
  Height = 480
  Caption = 'Check'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object SG: TStringGrid
    Left = 0
    Top = 0
    Width = 688
    Height = 405
    Align = alClient
    ColCount = 9
    DefaultColWidth = 80
    RowCount = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goThumbTracking]
    ParentFont = False
    TabOrder = 0
    OnDblClick = SGDblClick
    OnDrawCell = SGDrawCell
    OnSelectCell = SGSelectCell
    ColWidths = (
      80
      67
      97
      106
      87
      88
      70
      134
      101)
  end
  object FileListBox1: TFileListBox
    Left = 280
    Top = 120
    Width = 105
    Height = 145
    ItemHeight = 16
    TabOrder = 1
    Visible = False
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 405
    Width = 688
    Height = 19
    Panels = <
      item
        Width = 300
      end
      item
        Width = 50
      end>
  end
  object MainMenu1: TMainMenu
    Left = 480
    Top = 176
    object LoadFiles1: TMenuItem
      Caption = 'Load Files'
      OnClick = LoadFiles1Click
    end
    object RunCheck: TMenuItem
      Caption = '   Run Check  '
      OnClick = RunCheckClick
    end
    object Quit1: TMenuItem
      Caption = '  Quit  '
      OnClick = Quit1Click
    end
  end
  object OD: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 448
    Top = 176
  end
end
