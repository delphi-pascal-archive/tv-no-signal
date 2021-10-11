program Small;

uses
  Windows,
  Messages,
  Graphics,
  Classes;

  type
  TRGB = record
    b, g, r: byte;
  end;
  ARGB = array[0..1] of TRGB;
  PARGB = ^ARGB;

  const
  WinName = 'MainWClass';

  type
    TTimer = class(TThread)
    protected
      procedure Execute; override;
    public
    end;

  var
    hwndMain: HWND;
    AMessage: msg;
    WH, HE : integer;
    NaGText : string = 'd[^_^]b';
    Ticks : integer = 0;
    Tm : integer = 0;
    Timer : TTimer;
    Rec:TRect;
    WI : tagWINDOWINFO;

// ---------------------------------------------------------------------------//
procedure CanvasSetTextAngle(c: TCanvas; d: single);
  var   LogRec: TLOGFONT;  
begin
  GetObject(c.Font.Handle,SizeOf(LogRec) ,Addr(LogRec));
  if d <> 0 then
    if Random(2) = 1 then
    LogRec.lfEscapement := round(d)
    else
    LogRec.lfEscapement := -round(d);
  LogRec.lfQuality := 200;
  c.Font.Handle := CreateFontIndirect(LogRec);
end;
// ---------------------------------------------------------------------------//
procedure Draw(WIN: HWND);
var
  i,j : integer;
  x,y : integer;
  cl  : integer;
  sz  : integer; 
  bmp : TBitmap;
  cnx,cny : integer;
  p: PARGB;
  x1,y1 : integer;
  C : TCanvas;
begin
  bmp := TBitmap.Create;
  bmp.PixelFormat := pf24bit;
  bmp.Width := WH;
  bmp.Height := HE;

  for i := 0 to HE-1 do begin
    p := bmp.scanline[i];
    for j := 0 to WH-1 do begin
      cl := random(90);
      try
      p[j].r := cl;
      p[j].g := cl;
      p[j].b := cl;
      except
      end;
    end;
  end;
  {!}
  for i := 0 to 19 do
    if Random(70) = 5 then begin
      bmp.Canvas.Pen.Width := random(2);
      cl := random(70);
      bmp.Canvas.Pen.Color := RGB(cl,cl,cl);
      y := random(bmp.Height);
      bmp.Canvas.MoveTo(0,y);
      y := random(bmp.Height);
      bmp.Canvas.LineTo(bmp.Width,y);
    end;
    for i := 0 to 5 do
      if Random(35) = 5 then begin
        cl := random(150);
        sz := Random(30);
        bmp.Canvas.Pen.Color := RGB(cl,cl,cl);
        bmp.Canvas.Pen.Width := random(5);
        bmp.Canvas.Brush.Style := bsClear;
        y := random(bmp.Height);
        x := random(bmp.Width);
        bmp.Canvas.Ellipse(y+10,x+10,y+10+sz,x+10+sz);
      end;
  {!}
  if Random(80) = 1 then begin
    x1 := (bmp.Width div 2)+Random(5);
    y1 := (bmp.Height div 2)+Random(15);
    x := x1 - (x1+(y1 div 2)-(x1 div 2));
    bmp.Canvas.Pen.Width := random(20);
    bmp.Canvas.Brush.Style := bsClear;
    cl := random(90);
    bmp.Canvas.Pen.Color := RGB(cl,cl,cl);
    bmp.Canvas.Ellipse(x1-(y1 div 2)-(x1 div 2) + x{!}, y1-(y1 div 2),x1+(y1 div 2)-(x1 div 2) + x {!},y1+(y1 div 2));
    bmp.Canvas.Ellipse(x1-(y1 div 2)+(x1 div 2) - x, y1-(y1 div 2),x1+(y1 div 2)+(x1 div 2) - x,y1+(y1 div 2));
  end;
  {!}
  bmp.Canvas.Brush.Style := bsClear;
  bmp.Canvas.Font.Color  := clSilver;
  bmp.Canvas.Font.Name   := 'Arial';
  bmp.Canvas.Font.Style  := [] + [fsBold];
  bmp.Canvas.Font.Size   := 16;
  {!}
  cnx := (bmp.Width div 2) - (bmp.Canvas.TextWidth(NaGText) div 2);
  cny := (bmp.Height div 2) - (bmp.Canvas.TextHeight(NaGText) div 2);
  {!}
  if random(21) = 3 then begin
    CanvasSetTextAngle(bmp.Canvas,random(30));
  end else
    CanvasSetTextAngle(bmp.Canvas,0);
  {!}
  if Random(70) = 7 then begin
    x1 := Random(bmp.Width);
    y1 := Random(bmp.Height);
    bmp.Canvas.TextOut(x1-Random(2),y1+Random(2),NaGText);
    bmp.Canvas.Font.Color  := clWhite;
    bmp.Canvas.TextOut(x1-Random(2),y1+Random(2),NaGText);
  end else begin
    bmp.Canvas.TextOut(cnx-Random(2),cny+Random(2),NaGText);
    bmp.Canvas.Font.Color  := clWhite;
    bmp.Canvas.TextOut(cnx-Random(2),cny+Random(2),NaGText);
  end;
  {!}
  DrawFocusRect(WIN,bmp.Canvas.ClipRect);
  C := TCanvas.Create;
  C.Handle := GetDC(WIN);
  C.Draw(0,0,bmp);
  C.Free;
  {!}
  bmp.Free;
end;
// ---------------------------------------------------------------------------//
Procedure Timers;
begin
  Ticks := Ticks + 50;
  if Ticks >= 3000 then begin
    Tm := Tm + 1;
    Ticks := 0;
    case tm of
      1 : NaGText := 'ВНИМАНИЕ! Нет сигнала сети!';
      2 : NaGText := 'БЕЗ ПАНИКИ!!!';
      3 : NaGText := ' ---';
      4 : NaGText := ' ПОКА ИДЕТ рябь вы можете: ';
      5 : NaGText := ' Сварить суп ';
      6 : NaGText := ' Покормить котов ';
      7 : NaGText := ' Вынести мусор ';
      8 : NaGText := ' Помыть полы ';
      9 : NaGText := ' вытереть пыль ';
      10 : NaGText := ' позвонить подруге ';
      11 : NaGText := ' ... а можно и не звонить =) ';
      12 : NaGText := ' Можете бросить курить... ';
      13 : NaGText := ' Хм... в общем заняться чем нить полезным!';
      14 : NaGText := ' а можете просто... ';
      15 : NaGText := ' ...забить на все...';
      16 : NaGText := ' выключить эту программу и пойти пить пиво';
      17 : NaGText := ' ';
      18 : NaGText := 'Автор: BlackCash';
      19 : NaGText := 'eMail: BlackCash2006@Yandex.ru';
      20 : begin
            NaGText := 'THE END';
            tm := 0;
           end;
      end;
  end;
  Draw(hwndMain);
  UpdateWindow(hwndMain);
  Sleep(50);
end;
// ---------------------------------------------------------------------------//
Procedure TTimer.Execute;
begin
  while 1 = 1 do
    Timers;
end;
// ---------------------------------------------------------------------------//
function MainWndProc(Window: HWnd; AMessage, WParam, LParam: Longint): Longint; stdcall;
begin
case AMessage of
   WM_DESTROY:
   begin
     PostQuitMessage(0);
     Result := 0;
     Exit;
   end;
   else
     Result := DefWindowProc(Window, AMessage, WParam, LParam);
end;
end;

function InitApplication: Boolean;
  var
  wcx: TWndClass;
begin
  wcx.style := CS_HREDRAW or CS_VREDRAW;
  wcx.lpfnWndProc := @MainWndProc;
  wcx.cbClsExtra := 0;
  wcx.cbWndExtra := 0;
  wcx.hInstance := hInstance;
  wcx.hIcon := LoadIcon(0, IDI_APPLICATION);
  wcx.hCursor := LoadCursor(0, IDC_ARROW);
  wcx.hbrBackground := COLOR_WINDOW;
  wcx.lpszMenuName := nil;
  wcx.lpszClassName := PChar(WinName);
  Result := Windows.RegisterClass(wcx) <> 0;
end;

function InitInstance: HWND;
begin
  Result := CreateWindow(
  PChar(WinName),
  'TV - No signal...',
  WS_OVERLAPPEDWINDOW,
  Integer(CW_USEDEFAULT),
  Integer(CW_USEDEFAULT),
  640,
  480,
  0,0,hInstance,
  nil);
end;

begin
if (not InitApplication) then
   MessageBox(0, 'Ошибка регистрации окна', nil, mb_Ok)
else
begin
   hwndMain := InitInstance;
   if (hwndMain = 0) then
     MessageBox(0, 'Ошибка создания окна', nil, mb_Ok)
   else
   begin
     Timer := TTimer.Create(False);
     ShowWindow(hwndMain, CmdShow);
     UpdateWindow(hwndMain);
     while  (GetMessage(AMessage, 0, 0, 0)) do
     begin
       GetWindowInfo(hwndMain, WI);
       WH := WI.rcWindow.Right - WI.rcWindow.Left;
       HE := WI.rcWindow.Bottom - WI.rcWindow.Top;
       TranslateMessage(AMessage);
       DispatchMessage(AMessage);
     end;
   end;
end;

end.