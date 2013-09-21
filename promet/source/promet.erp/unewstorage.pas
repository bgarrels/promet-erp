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
*******************************************************************************}
unit uNewStorage;
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls, ExtCtrls, Buttons,
  uData, db,LCLType, ButtonPanel,uOrder,uMasterdata,uBaseERPDBClasses;
type
  TfNewStorage = class(TForm)
    ButtonPanel1: TButtonPanel;
    StorageType: TDatasource;
    gStorage: TDBGrid;
    lArticlewithoutStorage: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { private declarations }
  public
    { public declarations }
    function Execute(aOrder : TOrder;aStorage : TStorage) : Boolean;
    procedure SetLanguage;
  end;
var
  fNewStorage: TfNewStorage;
implementation
resourcestring
  strSelectanStorage            = 'Please select an Storage for the Article %s Version %s Name %s';
procedure TfNewStorage.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    begin
      Key := 0;
      Close;
    end;
end;
procedure TfNewStorage.SetLanguage;
begin
  if not Assigned(Self) then
    begin
      Application.CreateForm(TfNewStorage,fNewStorage);
      Self := fNewStorage;
    end;
end;
function TfNewStorage.Execute(aOrder : TOrder;aStorage : TStorage): Boolean;
var
  CtrDisabled: Boolean;
  ActControl: TWinControl;
  aStorageType : TStorageTyp;
begin
  if not Assigned(Self) then
    begin
      Application.CreateForm(TfNewStorage,fNewStorage);
      Self := fNewStorage;
    end;
  aStorageType := TStorageTyp.Create(Self,Data,aStorage.Connection);
  CtrDisabled := aStorageType.DataSet.ControlsDisabled;
  aStorageType.Open;
  StorageType.DataSet := aStorageType.DataSet;
  lArticlewithoutStorage.Caption := Format(strSelectanStorage,[aOrder.Positions.FieldByName('IDENT').AsString,
                                                               aOrder.Positions.FieldByName('VERSION').AsString,
                                                               aOrder.Positions.FieldByName('SHORTTEXT').AsString]);
  Result := ShowModal = mrOK;
  if Result then
    if not aStorage.DataSet.Locate('STORAGEID',aStorageType.FieldByName('ID').AsString,[loCaseInsensitive]) then
      with aStorage.DataSet do
        begin
          Insert;
          if aStorage.DataSet.FieldDefs.IndexOf('TYPE') > -1 then
            begin
              FieldByName('TYPE').AsVariant := aOrder.Positions.FieldByName('TYPE').AsVariant;
              FieldByName('ID').AsVariant := aOrder.Positions.FieldByName('ID').AsVariant;
              FieldByName('VERSION').AsVariant := aOrder.Positions.FieldByName('VERSION').Asvariant;
              FieldByName('LANGUAGE').AsVariant := aOrder.Positions.FieldByName('LANGUAGE').AsVariant;
            end;
          FieldByName('STORAGEID').AsVariant := aStorageType.FieldByName('ID').AsVariant;
          FieldByName('STORNAME').AsVariant := aStorageType.FieldByName('NAME').AsVariant;
          FieldByName('QUANTITY').AsFloat := 0;
          FieldByName('QUANTITYU').AsString := aOrder.Positions.FieldByName('QUANTITYU').AsString;
          Post;
        end;
  StorageType.DataSet := nil;
  aStorageType.Free;
  FreeAndNil(fNewStorage);
end;
initialization
  {$I unewstorage.lrs}
end.

