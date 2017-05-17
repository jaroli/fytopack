object CheckEditorForm: TCheckEditorForm
  Left = 299
  Top = 210
  Width = 682
  Height = 535
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
    Height = 460
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
    Top = 460
    Width = 674
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object MainMenu1: TMainMenu
    Left = 248
    Top = 96
    object SaveAndClose: TMenuItem
      Caption = 'Save And Close'
      OnClick = SaveAndCloseClick
    end
    object Cancel: TMenuItem
      Caption = 'Cancel'
      OnClick = CancelClick
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer1Timer
    Left = 168
    Top = 96
  end
  object FindDialog1: TFindDialog
    Left = 208
    Top = 96
  end
end
