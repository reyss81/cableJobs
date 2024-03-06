unit uMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.Bind.Controls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Vcl.StdCtrls, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Buttons, Vcl.Bind.Navigator,
  Vcl.Grids, Vcl.WinXCtrls, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.ComCtrls,
  Data.Bind.EngExt, Vcl.Bind.DBEngExt, Vcl.Bind.Grid, System.Rtti,
  System.Bindings.Outputs, Vcl.Bind.Editors, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, Vcl.WinXCalendars, FireDAC.Stan.StorageBin,
  FireDAC.Stan.StorageJSON, FireDAC.Stan.StorageXML,
  Vcl.WinXPanels, System.Actions, Vcl.ActnList, Vcl.Themes,
  Vcl.BaseImageCollection, Vcl.ImageCollection, System.ImageList, Vcl.ImgList,
  Vcl.VirtualImageList, Vcl.VirtualImage, System.IOUtils, Vcl.TitleBarCtrls,
  Data.Win.ADODB, Vcl.DBGrids, Vcl.WinXPickers, Vcl.DBCtrls,
  uGallery, Vcl.Samples.Spin;

type



  TMainForm = class(TForm)
    pnlToolbar: TPanel;
    SplitView: TSplitView;
    NavPanel: TPanel;
    lblTitle: TLabel;
    PageControl: TPageControl;
    CalendarTab: TTabSheet;
    Image5: TImage;
    CalendarView1: TCalendarView;
    Panel4: TPanel;
    Label3: TLabel;
    DashboardTab: TTabSheet;
    Panel5: TPanel;
    AccountsTab: TTabSheet;
    TitleBarPanel: TTitleBarPanel;
    VirtualImageList1: TVirtualImageList;
    ImageCollection1: TImageCollection;
    DashboardButton: TButton;
    GalleryButton: TButton;
    CalendarButton: TButton;
    VirtualImage1: TVirtualImage;
    VirtualImage6: TVirtualImage;
    MenuVirtualImage: TVirtualImage;
    VCLStylesCB: TComboBox;
    Panel1: TPanel;
    RefreshAcctButton: TSpeedButton;
    CreateAcctButton: TSpeedButton;
    ADOConnection1: TADOConnection;
    n_jobs: TADOTable;
    ds_n_jobs: TDataSource;
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    DatePicker1: TDatePicker;
    Label5: TLabel;
    ComboBox1: TComboBox;
    t_jobs: TADOTable;
    ds_t_jobs: TDataSource;
    q_jobs: TADOQuery;
    ds_q_jobs: TDataSource;
    q_jobsjobnumber: TWideStringField;
    q_jobsjobtype: TWordField;
    q_jobsjobdate: TDateTimeField;
    q_jobsjobdone: TBooleanField;
    q_jobsjobdetails: TWideStringField;
    q_jobsjobphotos: TWideStringField;
    q_jobsjobpayrate: TBCDField;
    q_jobsjobweek: TWordField;
    q_jobsjobcode: TWideStringField;
    Panel2: TPanel;
    DBGrid1: TDBGrid;
    Panel3: TPanel;
    t_jobsjobnumber: TWideStringField;
    t_jobsjobtype: TWordField;
    t_jobsjobdate: TDateTimeField;
    t_jobsjobdone: TBooleanField;
    t_jobsjobdetails: TWideStringField;
    t_jobsjobphotos: TWideStringField;
    t_jobsjobpayrate: TBCDField;
    t_jobsjobweek: TIntegerField;
    q_aux: TADOQuery;
    n_jobsjobtype: TWordField;
    n_jobsjobcode: TWideStringField;
    n_jobsjobdesc: TWideStringField;
    n_jobsjobpayrate: TBCDField;
    SpinEdit1: TSpinEdit;
    Label4: TLabel;
    UpDown1: TUpDown;
    Image1: TImage;
    DBGrid2: TDBGrid;
    q_master: TADOQuery;
    ds_q_master: TDataSource;
    q_masterjobweek: TIntegerField;
    q_mastertotal: TBCDField;
    q_masterdatestart: TDateTimeField;
    q_masterdateend: TDateTimeField;
    t_jobsjobcode: TStringField;
    VirtualImageList2: TVirtualImageList;
    ImageCollection2: TImageCollection;
    VirtualImage2: TVirtualImage;
    procedure CalendarView1DrawDayItem(Sender: TObject;
      DrawParams: TDrawViewInfoParams; CalendarViewViewInfo: TCellItemViewInfo);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure VCLStylesCBChange(Sender: TObject);
    procedure SplitViewOpening(Sender: TObject);
    procedure SplitViewClosing(Sender: TObject);
    procedure DashboardButtonClick(Sender: TObject);
    procedure MenuVirtualImageClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure UsernameComboBoxKeyPress(Sender: TObject; var Key: Char);
    procedure VCLStylesCBKeyPress(Sender: TObject; var Key: Char);
    procedure RefreshAcctButtonClick(Sender: TObject);
    procedure CreateAcctButtonClick(Sender: TObject);
    procedure UpDown1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure q_jobsAfterScroll(DataSet: TDataSet);
  private
    { Private declarations }
    FRanOnce: Boolean;
    procedure AppIdle(Sender: TObject; var Done: Boolean);
    procedure UpdateNavButtons;
    procedure getDate(Sender: TObject);
    procedure RepaintGallery;
  public
    { Public declarations }
    appRoot: string;
    galleryPhotos: array of TGalleryImage;
    imagesJob: array of string;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses uDataMod;

procedure TMainForm.CalendarView1DrawDayItem(Sender: TObject;
  DrawParams: TDrawViewInfoParams; CalendarViewViewInfo: TCellItemViewInfo);
begin
  if DayOfWeek(CalendarViewViewInfo.Date) in [1, 7] then
  begin
    DrawParams.Font.Style := [fsBold];
  end;
end;

procedure TMainForm.CreateAcctButtonClick(Sender: TObject);
var
  i, j: integer;
  weekFirstDay: byte;
  c: integer;
  aYear, aMonth, aDay: word;
  tMonth, tDay, index: string;
  images, filenewname: string;
  find: boolean;
begin
  weekFirstDay:= 1; //numeracion de las semanas que se van trabajando...
  images:= '';
  c:= 0;
  for i:=0 to high(galleryPhotos) do
  begin
    if galleryPhotos[i].selected then
    begin
      inc(c);
      index:= IntToStr(c);
      DecodeDate(DatePicker1.Date, aYear, aMonth, aDay);
      tMonth:= IntToStr(aMonth);
      tDay:= IntToStr(aDay);
      if length(tMonth)=1 then  tMonth:= '0'+tMonth;
      if length(tDay)=1 then  tDay:= '0'+tDay;
      if length(index)=1 then  index:= '0'+index;
      ForceDirectories(appRoot+IntToStr(aYear)+'\'+tMonth+'\');
      filenewname:= IntToStr(aYear)+tMonth+tDay+'_Job_'+Edit1.Text+'_'+index+ExtractFileExt(galleryPhotos[i].filename);
      if MoveFile(PChar(galleryPhotos[i].filename),PChar(appRoot+IntToStr(aYear)+'\'+tMonth+'\'+filenewname)) then
      begin
        images:= images+filenewname+';'
      end;
      FreeAndNil(galleryPhotos[i]);
      galleryPhotos[i]:= nil;
    end;
  end;
  if c>0 then //hubo seleccionados
  begin
    q_aux.Active:= false;
    q_aux.SQL.Clear;
    q_aux.SQL.Add('SELECT * FROM n_jobs WHERE (jobcode='''+ComboBox1.Text+''')');
    q_aux.Active:= true;
    t_jobs.Insert;
    t_jobs.Edit;
    t_jobsjobnumber.Value:= Edit1.Text;
    t_jobsjobtype.Value:= q_aux.FieldValues['jobtype'];
    t_jobsjobdate.Value:= DatePicker1.Date;
    t_jobsjobdone.Value:= true;
    t_jobsjobdetails.Value:= '';
    t_jobsjobphotos.Value:= images;
    t_jobsjobpayrate.Value:= q_aux.FieldValues['jobpayrate'];
    t_jobsjobweek.Value:= SpinEdit1.Value;
    t_jobs.Post;
    q_jobs.Active:= false;
    q_jobs.Active:= true;
  end;
  for i:=0 to high(galleryPhotos) do
  begin
    if galleryPhotos[i]=nil then
    begin
      find:= false;
      for j:=i+1 to high(galleryPhotos) do
      begin
        if galleryPhotos[j]<>nil then
        begin
          galleryPhotos[i]:= galleryPhotos[j];
          galleryPhotos[j]:= nil;
          find:= true;
          break;
        end;
      end;
      if not find then  //ya no hay mas archivos
      begin
        break;
      end;
    end;
  end;
  setlength(galleryPhotos,i);
  if high(galleryPhotos)>0 then
  begin
    RepaintGallery();
  end;
end;

procedure TMainForm.PageControlChange(Sender: TObject);
begin
  if PageControl.ActivePageIndex=0 then
    begin
    end;
  case PageControl.ActivePageIndex of
    0: DashboardButton.SetFocus;
    1: GalleryButton.SetFocus;
    2: CalendarButton.SetFocus;
  end;
end;

procedure TMainForm.q_jobsAfterScroll(DataSet: TDataSet);
var
  temp, tMonth: string;
  c: integer;
  aYear, aMonth, aDay: word;
  allowChange: boolean;
begin
  c:= 0;
  temp:= q_jobsjobphotos.Value;
  while (pos(';',temp)>0) do
  begin
    DecodeDate(q_jobsjobdate.Value, aYear, aMonth, aDay);
    tMonth:= IntToStr(aMonth);
    if length(tMonth)=1 then  tMonth:= '0'+tMonth;
    inc(c);
    setlength(imagesJob,c);
    imagesJob[c-1]:= appRoot+IntToStr(aYear)+'\'+tMonth+'\'+copy(temp,1,pos(';',temp)-1);
    delete(temp,1,pos(';',temp));
  end;
  UpDown1.Max:= c-1;
  UpDown1.Position:= 0;
  UpDown1.OnChanging(Self,allowChange);
end;

procedure TmainForm.RepaintGallery();
var
   i, x, y, maxX: integer;
begin
  x:= 0; y:= 0; maxX:= ScrollBox1.Width div galleryPhotos[0].Width + 1;
  for i:=0 to high(galleryPhotos) do
  begin
    galleryPhotos[i].Left:= (galleryPhotos[0].Width+2)*x+1;
    galleryPhotos[i].Top:= (galleryPhotos[0].Height+2)*y+1;
    if x<maxX then
    begin
      inc(x);
    end else
    begin
      x:= 0;
      inc(y);
    end;
  end;

end;

procedure TMainForm.RefreshAcctButtonClick(Sender: TObject);
var
  galleryPath: String;
  SR: TSearchRec;
  w, h, c: integer;
begin
  for c:=0 to high(galleryPhotos) do
  begin
    if galleryPhotos[c]<>nil then
    begin
      try
        FreeAndNil(galleryPhotos[c]);
        except on exception do
        begin
        end;
      end;
    end;
  end;
  galleryPath := appRoot+'Temp\';
  if FindFirst(galleryPath+'*.*',faArchive, SR) = 0 then
  begin
    c:= 0;
    repeat
      try
        SetLength(galleryPhotos,c+1);
        galleryPhotos[c]:= TGalleryImage.Create(MainForm);
        galleryPhotos[c].Picture.LoadFromFile(galleryPath+SR.Name);
        galleryPhotos[c].filename:= galleryPath+SR.Name;
        if c=0 then //es el primer archivo
        begin
          galleryPhotos[c].AutoSize:= true;
          h:= trunc(galleryPhotos[c].Height*25/100);
          w:= trunc(galleryPhotos[c].Width*25/100);
          galleryPhotos[c].AutoSize:= false;
        end;
        galleryPhotos[c].Width:= w-2;
        galleryPhotos[c].Height:= h-2;
        galleryPhotos[c].Stretch:= true;
        galleryPhotos[c].Proportional:= true;
        galleryPhotos[c].Parent:= ScrollBox1;
        galleryPhotos[c].OnDblClick:= getDate;
        except
        on exception do
        begin
           FreeAndNil(galleryPhotos[c]);
           dec(c);
        end;
      end;
      inc(c);
    until FindNext(SR) <> 0;
    FindClose(SR);
    if high(galleryPhotos)>0 then
    begin
      RepaintGallery();
    end;
  end;
end;

procedure TMainForm.SplitViewClosing(Sender: TObject);
begin
  DashboardButton.Caption := '';
  GalleryButton.Caption := '';
  CalendarButton.Caption := '';
end;

procedure TMainForm.SplitViewOpening(Sender: TObject);
begin
  DashboardButton.Caption := '          '+DashboardButton.Hint;
  GalleryButton.Caption := '          '+GalleryButton.Hint;
  CalendarButton.Caption := '          '+CalendarButton.Hint;
end;

procedure TMainForm.UsernameComboBoxKeyPress(Sender: TObject; var Key: Char);
begin
  Key := #0;
end;

procedure TMainForm.VCLStylesCBChange(Sender: TObject);
begin
  MainForm.WindowState := TWindowState.wsMaximized;
  TStyleManager.TrySetStyle(VCLStylesCB.Text);
  UpdateNavButtons;
end;

procedure TMainForm.VCLStylesCBKeyPress(Sender: TObject; var Key: Char);
begin
  Key := #0;
end;

procedure TMainForm.MenuVirtualImageClick(Sender: TObject);
begin
  SplitView.Opened := not SplitView.Opened;
end;

procedure TMainForm.DashboardButtonClick(Sender: TObject);
begin
  PageControl.ActivePageIndex:= TButton(Sender).Tag;
end;

procedure TMainForm.AppIdle(Sender: TObject; var Done: Boolean);
begin
  if not FRanOnce then
  begin
    FRanOnce := True;

    //DM.InitializeDatabase;

    DashboardButton.SetFocus;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  StyleName: string;
  i: integer;
begin

  ComboBox1.Items.Clear;
  n_jobs.First;
  for i:=1 to n_jobs.RecordCount do
  begin
    ComboBox1.Items.Add(n_jobsjobcode.Value);
    n_jobs.Next;
  end;
  n_jobs.First;

  Application.OnIdle := AppIdle;

  appRoot:= ExtractFilePath(Application.ExeName); // con "\" al final

  for StyleName in TStyleManager.StyleNames do
    VCLStylesCB.Items.Add(StyleName);

  VCLStylesCB.ItemIndex := VCLStylesCB.Items.IndexOf(TStyleManager.ActiveStyle.Name);

  UpdateNavButtons;
end;

procedure TMainForm.UpdateNavButtons;
var
  LStyle: Dword;
begin
  LStyle := GetWindowLong(DashboardButton.Handle, GWL_STYLE);
  SetWindowLong(DashboardButton.Handle, GWL_STYLE, LStyle or BS_LEFT);
  DashboardButton.Caption := '          '+DashboardButton.Hint;
  SetWindowLong(GalleryButton.Handle, GWL_STYLE, LStyle or BS_LEFT);
  GalleryButton.Caption := '          '+GalleryButton.Hint;
   SetWindowLong(CalendarButton.Handle, GWL_STYLE, LStyle or BS_LEFT);
  CalendarButton.Caption := '          '+CalendarButton.Hint;
end;

procedure TMainForm.UpDown1Changing(Sender: TObject; var AllowChange: Boolean);
begin
  try
    Image1.Picture.LoadFromFile(imagesJob[UpDown1.Position]);
    except on exception do
    begin
       ShowMessage(imagesJob[UpDown1.Position]);
    end;
  end;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  if MainForm.Width<=640 then
  begin
    if SplitView.Opened=True then SplitView.Opened := False;
  end
  else
  begin
    if SplitView.Opened=False then SplitView.Opened := True;
  end;
end;

procedure TMainForm.getDate(Sender: TObject);
var
  filename: string;
begin
  filename:= (Sender as TGalleryImage).filename;
  DatePicker1.Date:=  FileDateToDateTime(FileAge(filename));
end;

end.
