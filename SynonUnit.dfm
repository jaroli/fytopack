object SynF: TSynF
  Left = 261
  Top = 52
  Width = 825
  Height = 683
  Caption = 'Synon'
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
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object StatusBar1: TStatusBar
    Left = 0
    Top = 600
    Width = 817
    Height = 27
    Panels = <
      item
        Width = 300
      end
      item
        Width = 50
      end>
  end
  object SG: TStringGrid
    Left = 0
    Top = 0
    Width = 817
    Height = 600
    Align = alClient
    ColCount = 12
    DefaultColWidth = 100
    RowCount = 1
    FixedRows = 0
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Courier New'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goTabs, goThumbTracking]
    ParentFont = False
    TabOrder = 1
    OnDblClick = SGDblClick
    OnDrawCell = SGDrawCell
    OnSelectCell = SGSelectCell
  end
  object FileListBox1: TFileListBox
    Left = 120
    Top = 176
    Width = 145
    Height = 97
    ItemHeight = 16
    TabOrder = 2
    Visible = False
  end
  object ChL: TStringGrid
    Left = 80
    Top = 336
    Width = 697
    Height = 120
    ColCount = 7
    DefaultColWidth = 120
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    TabOrder = 3
    Visible = False
  end
  object MainMenu1: TMainMenu
    Left = 360
    Top = 200
    object LoadFile: TMenuItem
      Caption = 'Load Files'
      OnClick = LoadFileClick
    end
    object RunSynon: TMenuItem
      Caption = 'Run Synon'
      OnClick = RunSynonClick
    end
    object Quit: TMenuItem
      Caption = 'Quit'
      OnClick = QuitClick
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Data Files(*.dat;*.DAT)|*.dat;*.DAT|Any File(*.*)|*.*'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 400
    Top = 200
  end
end
