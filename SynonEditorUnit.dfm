object SynonEditorForm: TSynonEditorForm
  Left = 352
  Top = 174
  Width = 682
  Height = 541
  Caption = 'Simple Text Editor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 674
    Height = 466
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Courier'
    Font.Style = []
    Lines.Strings = (
      'Memo1')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    OnKeyDown = Memo1KeyDown
    OnKeyUp = Memo1KeyUp
    OnMouseDown = Memo1MouseDown
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 466
    Width = 674
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object MainMenu1: TMainMenu
    Left = 88
    Top = 88
    object SaveAndClose: TMenuItem
      Caption = 'Save And Close'
      OnClick = SaveAndCloseClick
    end
    object Cancel: TMenuItem
      Caption = 'Cancel'
      OnClick = CancelClick
    end
  end
  object FindDialog1: TFindDialog
    Left = 256
    Top = 112
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer1Timer
    Left = 88
    Top = 152
  end
end
