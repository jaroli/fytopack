object ZipLineForm: TZipLineForm
  Left = 305
  Top = 184
  Width = 898
  Height = 562
  Caption = 'ZipLine'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object StatusBar1: TStatusBar
    Left = 0
    Top = 487
    Width = 890
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 890
    Height = 487
    ActivePage = TabSheet3
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      object SG: TStringGrid
        Left = 0
        Top = 0
        Width = 882
        Height = 456
        Align = alClient
        ColCount = 1
        DefaultColWidth = 1200
        FixedCols = 0
        RowCount = 2
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Courier'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goRowSelect, goThumbTracking]
        ParentFont = False
        TabOrder = 0
        OnDblClick = SGDblClick
        OnDrawCell = SGDrawCell
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 882
        Height = 456
        Align = alClient
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
      ImageIndex = 2
      object Memo2: TMemo
        Left = 0
        Top = 0
        Width = 882
        Height = 456
        Align = alClient
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 400
    Top = 232
    object LoadFile: TMenuItem
      Caption = 'Load File'
      OnClick = LoadFileClick
    end
    object ZipLines: TMenuItem
      Caption = 'Zip Lines'
      OnClick = ZipLinesClick
    end
    object Quit: TMenuItem
      Caption = 'Quit'
      OnClick = QuitClick
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Data Files(*.dat;*.DAT)|*.dat;*.DAT|Any File(*.*)|*.*'
    Left = 360
    Top = 224
  end
end
