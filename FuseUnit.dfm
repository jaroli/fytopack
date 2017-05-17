object FuseForm: TFuseForm
  Left = 332
  Top = 170
  Width = 576
  Height = 522
  Caption = 'Fuse'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 32
    Top = 24
    Width = 186
    Height = 16
    Caption = 'Files in directory CheckedData:'
  end
  object Label2: TLabel
    Left = 320
    Top = 24
    Width = 84
    Height = 16
    Caption = 'Selected files:'
  end
  object Bevel1: TBevel
    Left = 0
    Top = 0
    Width = 568
    Height = 447
    Align = alClient
    Shape = bsTopLine
  end
  object FL: TFileListBox
    Left = 32
    Top = 48
    Width = 217
    Height = 337
    ExtendedSelect = False
    ItemHeight = 16
    MultiSelect = True
    TabOrder = 0
    OnClick = FLClick
  end
  object ProgressBar1: TProgressBar
    Left = 96
    Top = 408
    Width = 377
    Height = 20
    Step = 1
    TabOrder = 1
    Visible = False
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 447
    Width = 568
    Height = 19
    Panels = <
      item
        Width = 300
      end
      item
        Width = 50
      end>
    SimplePanel = True
  end
  object M: TListBox
    Left = 320
    Top = 48
    Width = 209
    Height = 337
    ItemHeight = 16
    TabOrder = 3
    OnClick = MClick
  end
  object MainMenu1: TMainMenu
    Left = 272
    Top = 32
    object SelectAllFiles: TMenuItem
      Caption = 'Select All Files'
      OnClick = SelectAllFilesClick
    end
    object ClearSelectedFiles: TMenuItem
      Caption = 'Clear Selected Files'
      OnClick = ClearSelectedFilesClick
    end
    object RunFuse: TMenuItem
      Caption = 'Run Fuse'
      OnClick = RunFuseClick
    end
    object Quit: TMenuItem
      Caption = 'Quit'
      OnClick = QuitClick
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 136
    Top = 152
  end
end
