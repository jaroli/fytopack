object FytopackForm: TFytopackForm
  Left = 226
  Top = 214
  Width = 870
  Height = 500
  Caption = 'Fytopack2004'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object PC: TPageControl
    Left = 0
    Top = 0
    Width = 862
    Height = 425
    Align = alClient
    TabOrder = 0
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 425
    Width = 862
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
    Left = 304
    Top = 160
    object FileBtn: TMenuItem
      Caption = 'File'
      OnClick = FileBtnClick
      object Open: TMenuItem
        Caption = 'Open'
      end
      object Save: TMenuItem
        Caption = 'Save'
      end
      object SaveAs: TMenuItem
        Caption = 'Save As'
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object PrintSetup: TMenuItem
        Caption = 'Print Setup'
      end
      object PageSetup: TMenuItem
        Caption = 'Page Setup'
      end
      object Print1: TMenuItem
        Caption = 'Print'
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Close: TMenuItem
        Caption = 'Close'
      end
      object CloseAll: TMenuItem
        Caption = 'Close All'
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Quit: TMenuItem
        Caption = 'Quit'
      end
    end
    object Edit: TMenuItem
      Caption = 'Edit'
      OnClick = EditClick
      object Undo: TMenuItem
        Caption = 'Undo'
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Cut: TMenuItem
        Caption = 'Cut'
      end
      object Copy: TMenuItem
        Caption = 'Copy'
      end
      object Paste: TMenuItem
        Caption = 'Paste'
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object SelectAll: TMenuItem
        Caption = 'Select All'
      end
      object Delete: TMenuItem
        Caption = 'Delete'
      end
    end
    object Search: TMenuItem
      Caption = 'Search'
      object Find: TMenuItem
        Caption = 'Find'
      end
      object FindNext: TMenuItem
        Caption = 'Find Next'
      end
      object Replace: TMenuItem
        Caption = 'Replace'
      end
      object FindFirst: TMenuItem
        Caption = 'Find First'
      end
    end
    object Format: TMenuItem
      Caption = 'Format'
      object Font: TMenuItem
        Caption = 'Font'
      end
      object MonospacedFonts: TMenuItem
        Caption = 'Monospaced Fonts'
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object Bold: TMenuItem
        Caption = 'Bold'
      end
      object Italic: TMenuItem
        Caption = 'Italic'
      end
      object Underline: TMenuItem
        Caption = 'Underline'
      end
      object Strikeout: TMenuItem
        Caption = 'Strikeout'
      end
      object Bullets: TMenuItem
        Caption = 'Bullets'
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object AlignLeft: TMenuItem
        Caption = 'Align Left'
      end
      object AlignRight: TMenuItem
        Caption = 'Align Right'
      end
      object Center: TMenuItem
        Caption = 'Center'
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object WordWrap: TMenuItem
        Caption = 'Word Wrap'
      end
    end
    object Check: TMenuItem
      Caption = 'Check'
    end
    object Fuse: TMenuItem
      Caption = 'Fuse'
    end
    object Synon: TMenuItem
      Caption = 'Synon'
    end
    object Fyt: TMenuItem
      Caption = 'Fyt'
      object LoadFileFyt: TMenuItem
        Caption = 'Load File'
      end
      object RunFyt: TMenuItem
        Caption = 'Run Fyt'
      end
      object AddFytList: TMenuItem
        Caption = 'Add Fyt List'
      end
    end
    object Synop: TMenuItem
      Caption = 'Synop'
      object LoadFileSynop: TMenuItem
        Caption = 'Load File'
      end
      object RunSynop: TMenuItem
        Caption = 'Run Synop'
      end
      object SettingsSynop: TMenuItem
        Caption = 'Settings'
        object Synop1: TMenuItem
          AutoCheck = True
          Caption = 'Synop1'
        end
        object Synop2: TMenuItem
          AutoCheck = True
          Caption = 'Synop2'
        end
        object Synop3: TMenuItem
          AutoCheck = True
          Caption = 'Synop3'
          Checked = True
        end
        object Synop4: TMenuItem
          AutoCheck = True
          Caption = 'Synop4'
        end
        object Synop5: TMenuItem
          AutoCheck = True
          Caption = 'Synop5'
        end
        object Synop6: TMenuItem
          AutoCheck = True
          Caption = 'Synop6'
        end
      end
    end
    object Fulnam: TMenuItem
      Caption = 'Fulnam'
      object RunFulnam: TMenuItem
        Caption = 'Run Fulnam'
      end
      object SettingsFulnam: TMenuItem
        Caption = 'Settings'
        object Author: TMenuItem
          AutoCheck = True
          Caption = 'Author'
        end
      end
    end
    object Utilities: TMenuItem
      Caption = 'Utilities'
      object SyntaxFormat: TMenuItem
        Caption = 'SyntaxFormat'
      end
      object ZipLine: TMenuItem
        Caption = 'ZipLine'
      end
      object SortLine: TMenuItem
        Caption = 'SortLine'
      end
      object Trunc: TMenuItem
        Caption = 'Trunc'
      end
      object OtherTaxa: TMenuItem
        Caption = 'OtherTaxa'
      end
    end
    object Help: TMenuItem
      Caption = 'Help'
    end
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 344
    Top = 160
  end
end
