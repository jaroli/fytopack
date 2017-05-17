object FytopackForm: TFytopackForm
  Left = 307
  Top = 121
  Width = 1292
  Height = 500
  Caption = 'Fytopack'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDefault
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object PC: TPageControl
    Left = 0
    Top = 0
    Width = 1284
    Height = 420
    Align = alClient
    TabOrder = 0
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 420
    Width = 1284
    Height = 24
    Panels = <
      item
        Width = 400
      end
      item
        Width = 50
      end>
  end
  object MainMenu1: TMainMenu
    Left = 144
    Top = 152
    object FileBtn: TMenuItem
      Caption = 'File'
      object Open: TMenuItem
        Caption = 'Open'
        OnClick = OpenClick
      end
      object Save: TMenuItem
        Caption = 'Save'
        OnClick = SaveClick
      end
      object SaveAs: TMenuItem
        Caption = 'Save As'
        OnClick = SaveAsClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object PrintSetup: TMenuItem
        Caption = 'Print Setup'
        OnClick = PrintSetupClick
      end
      object PageSetup: TMenuItem
        Caption = 'Page Setup'
        OnClick = PageSetupClick
      end
      object Print1: TMenuItem
        Caption = 'Print'
        OnClick = Print1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object CloseFile: TMenuItem
        Caption = 'Close'
        OnClick = CloseFileClick
      end
      object CloseAll: TMenuItem
        Caption = 'Close All'
        OnClick = CloseAllClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Quit: TMenuItem
        Caption = 'Quit'
        OnClick = QuitClick
      end
    end
    object Edit: TMenuItem
      Caption = 'Edit'
      object Undo: TMenuItem
        Caption = 'Undo'
        OnClick = UndoClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Cut: TMenuItem
        Caption = 'Cut'
        OnClick = CutClick
      end
      object CopyBtn: TMenuItem
        Caption = 'Copy'
        OnClick = CopyBtnClick
      end
      object Paste: TMenuItem
        Caption = 'Paste'
        OnClick = PasteClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object SelectAll: TMenuItem
        Caption = 'Select All'
        OnClick = SelectAllClick
      end
      object Delete: TMenuItem
        Caption = 'Delete'
        OnClick = DeleteClick
      end
    end
    object Search: TMenuItem
      Caption = 'Search'
      object Find: TMenuItem
        Caption = 'Find'
        OnClick = FindClick
      end
      object Replace: TMenuItem
        Caption = 'Replace'
        OnClick = ReplaceClick
      end
    end
    object Format: TMenuItem
      Caption = 'Format'
      object Font: TMenuItem
        Caption = 'Font'
        OnClick = FontClick
      end
      object MonospacedFonts: TMenuItem
        Caption = 'Monospaced Fonts'
        OnClick = MonospacedFontsClick
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object AlignLeft: TMenuItem
        AutoCheck = True
        Caption = 'Align Left'
        Checked = True
        GroupIndex = 13
        RadioItem = True
        OnClick = AlignLeftClick
      end
      object AlignRight: TMenuItem
        AutoCheck = True
        Caption = 'Align Right'
        GroupIndex = 13
        RadioItem = True
        OnClick = AlignRightClick
      end
      object Center: TMenuItem
        AutoCheck = True
        Caption = 'Center'
        GroupIndex = 13
        RadioItem = True
        OnClick = CenterClick
      end
      object N8: TMenuItem
        Caption = '-'
        GroupIndex = 13
      end
      object WordWrap: TMenuItem
        AutoCheck = True
        Caption = 'Word Wrap'
        GroupIndex = 13
        OnClick = WordWrapClick
      end
    end
    object Check: TMenuItem
      Caption = 'Check'
      OnClick = CheckClick
    end
    object Fuse: TMenuItem
      Caption = 'Fuse'
      OnClick = FuseClick
    end
    object Synon: TMenuItem
      Caption = 'Synon'
      OnClick = SynonClick
    end
    object Fyt: TMenuItem
      Caption = 'Fyt'
      object LoadFileFyt: TMenuItem
        Caption = 'Load File'
        OnClick = LoadFileFytClick
      end
      object RunFyt: TMenuItem
        Caption = 'Run Fyt'
        OnClick = RunFytClick
      end
      object SettingsFyt: TMenuItem
        Caption = 'Settings'
        object FytList: TMenuItem
          AutoCheck = True
          Caption = 'Fyt List'
        end
      end
    end
    object Synop: TMenuItem
      Caption = 'Synop'
      object LoadFileSynop: TMenuItem
        Caption = 'Load File'
        OnClick = LoadFileSynopClick
      end
      object RunSynop: TMenuItem
        Caption = 'Run Synop'
        OnClick = RunSynopClick
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
        OnClick = RunFulnamClick
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
        OnClick = SyntaxFormatClick
      end
      object ZipLine: TMenuItem
        Caption = 'ZipLine'
        OnClick = ZipLineClick
      end
      object SortLine: TMenuItem
        Caption = 'SortLine'
        OnClick = SortLineClick
      end
      object Trunc: TMenuItem
        Caption = 'Trunc'
        OnClick = TruncClick
      end
      object OtherTaxa: TMenuItem
        Caption = 'OtherTaxa'
        OnClick = OtherTaxaClick
      end
    end
    object Help: TMenuItem
      Caption = 'Help'
      OnClick = HelpClick
    end
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 176
    Top = 152
  end
  object OpenD: TOpenDialog
    Filter = 
      'Data Files(*.dat;*.DAT)|*.dat;*.DAT|List Files(*.lst;*.LST)|*.ls' +
      't;*.LST|All Files(*.*)|*.*'
    FilterIndex = 3
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 208
    Top = 152
  end
  object SaveD: TSaveDialog
    Left = 240
    Top = 152
  end
  object PrinterSetupDialog: TPrinterSetupDialog
    Left = 272
    Top = 152
  end
  object PageSetupDialog: TPageSetupDialog
    MinMarginLeft = 0
    MinMarginTop = 0
    MinMarginRight = 0
    MinMarginBottom = 0
    MarginLeft = 1000
    MarginTop = 1000
    MarginRight = 1000
    MarginBottom = 1000
    PageWidth = 8500
    PageHeight = 11000
    Left = 304
    Top = 152
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 336
    Top = 152
  end
  object FontDialog2: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [fdEffects, fdFixedPitchOnly]
    Left = 368
    Top = 152
  end
  object FindD: TFindDialog
    Options = [frDown, frHideWholeWord]
    OnFind = FindDFind
    Left = 400
    Top = 152
  end
  object ReplaceD: TReplaceDialog
    OnFind = ReplaceDFind
    OnReplace = ReplaceDReplace
    Left = 432
    Top = 152
  end
end
