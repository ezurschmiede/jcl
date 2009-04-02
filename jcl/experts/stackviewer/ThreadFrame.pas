unit ThreadFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, JclDebugStackUtils, StackViewUnit, StackFrame, ExceptInfoFrame;

type
  TfrmThread = class(TFrame)
    pnlExceptInfo: TPanel;
    pnlCreationStack: TPanel;
    pnlStack: TPanel;
    Splitter1: TSplitter;
  private
    FCreationStackFrame: TfrmStack;
    FExceptionFrame: TfrmException;
    FStackFrame: TfrmStack;
    FCreationStackList: TStackViewItemsList;
    FStackList: TStackViewItemsList;
    FException: TException;
    FLastStackFrame: TObject;
    procedure SetCreationStackList(const Value: TStackViewItemsList);
    procedure SetException(const Value: TException);
    procedure SetStackList(const Value: TStackViewItemsList);
    function GetSelected: TStackViewItem;
    procedure HandleStackSelection(ASender: TObject);
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent);
    property CreationStackList: TStackViewItemsList read FCreationStackList write SetCreationStackList;
    property Exception: TException read FException write SetException;
    property StackList: TStackViewItemsList read FStackList write SetStackList;
    property Selected: TStackViewItem read GetSelected;
  end;

implementation

{$R *.dfm}

{ TfrmThread }

constructor TfrmThread.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCreationStackFrame := TfrmStack.Create(Self);
  FCreationStackFrame.Name := 'ThreadCreationStackFrame';
  FCreationStackFrame.Parent := pnlCreationStack;
  FCreationStackFrame.Align := alClient;
  FCreationStackFrame.OnSelectStackLine := HandleStackSelection;
  FExceptionFrame := TfrmException.Create(Self);
  FExceptionFrame.Parent := pnlExceptInfo;
  FExceptionFrame.Align := alClient;
  FStackFrame := TfrmStack.Create(Self);
  FStackFrame.Name := 'ThreadStackFrame';
  FStackFrame.Parent := pnlStack;
  FStackFrame.Align := alClient;
  FStackFrame.OnSelectStackLine := HandleStackSelection;
  FLastStackFrame := nil;
end;

function TfrmThread.GetSelected: TStackViewItem;
begin
  if (FLastStackFrame = FStackFrame) and FStackFrame.Visible and Assigned(FStackFrame.Selected) then
    Result := FStackFrame.Selected
  else
  if (FLastStackFrame = FCreationStackFrame) and FCreationStackFrame.Visible and Assigned(FCreationStackFrame.Selected) then
    Result := FCreationStackFrame.Selected
  else
    Result := nil;
end;

procedure TfrmThread.HandleStackSelection(ASender: TObject);
begin
  FLastStackFrame := ASender;
end;

procedure TfrmThread.SetCreationStackList(const Value: TStackViewItemsList);
begin
  FCreationStackList := Value;
  FCreationStackFrame.StackList := FCreationStackList;
  pnlCreationStack.Visible := Assigned(FCreationStackList);
end;

procedure TfrmThread.SetException(const Value: TException);
begin
  FException := Value;
  FExceptionFrame.Exception := FException;
  pnlExceptInfo.Visible := Assigned(FException);
end;

procedure TfrmThread.SetStackList(const Value: TStackViewItemsList);
begin
  FStackList := Value;
  FStackFrame.StackList := FStackList;
  pnlStack.Visible := Assigned(FStackList);
end;

end.