{*******************************************************************************
  Copyright (C) Christian Ulrich info@cu-tec.de

  This source is free software; you can redistribute it and/or modify it under
  the terms of the GNU General Public License as published by the Free
  Software Foundation; either version 2 of the License, or commercial alternative
  contact us for more information

  This code is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  A copy of the GNU General Public License is available on the World Wide Web
  at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
  to the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
  MA 02111-1307, USA.
Created 07.06.2014
*******************************************************************************}
unit uPasswords;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids,
  ComCtrls, ActnList, DBActns,uPasswordSave, Grids;

type

  { TfPasswords }

  TfPasswords = class(TForm)
    acCopy: TAction;
    acGenerate: TAction;
    ActionList1: TActionList;
    DataSetCancel1: TDataSetCancel;
    DataSetDelete1: TDataSetDelete;
    DataSetInsert1: TDataSetInsert;
    DataSetPost1: TDataSetPost;
    DataSetRefresh1: TDataSetRefresh;
    PwSave: TDatasource;
    DBGrid1: TDBGrid;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    procedure acGenerateExecute(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    DataSet: TPasswordSave;
    function Execute : Boolean;
    procedure SetLanguage;
  end;

var
  fPasswords: TfPasswords;

implementation
uses uData,upasswordgenerate;
{$R *.lfm}

{ TfPasswords }

procedure TfPasswords.FormDestroy(Sender: TObject);
begin
end;

procedure TfPasswords.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  DataSet.Free;
end;

procedure TfPasswords.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if Column.FieldName='PASSWORD' then
    begin
      Canvas.FillRect(Rect);
      Canvas.TextOut(Rect.Left+2, Rect.Top+2, '***********');
    end
  else
    DBGrid1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TfPasswords.acGenerateExecute(Sender: TObject);
begin
  if fPWGenerate.Execute then
    begin
      DataSet.Edit;
      DataSet.FieldByName('PASSWORD').AsString:=fPWGenerate.ePassword.Text;
    end;
end;

function TfPasswords.Execute: Boolean;
begin
  if not Assigned(Self) then
    begin
      Application.CreateForm(TfPasswords,fPasswords);
      Self := fPasswords;
    end;
  SetLanguage;
  DataSet := TPasswordSave.CreateEx(nil,Data,nil,Data.Users.DataSet);
  DataSet.CreateTable;
  DataSet.Open;
  PwSave.DataSet := DataSet.DataSet;
  Show;
end;

procedure TfPasswords.SetLanguage;
begin

end;

end.

