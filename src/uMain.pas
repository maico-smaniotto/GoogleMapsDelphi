unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, StdCtrls, ExtCtrls, ComCtrls, MSHTML, Activex,
  Buttons;

type
  TFrmMain = class(TForm)
    WebBrowser: TWebBrowser;
    PanelHeader: TPanel;
    btLocaliza: TButton;
    LabelLatitude: TLabel;
    LabelLongitude: TLabel;
    Longitude: TEdit;
    Latitude: TEdit;
    btLimpa: TButton;
    Lista_Localizacao: TListView;
    Panel1: TPanel;
    LocalizaEndereco: TBitBtn;
    CEP: TEdit;
    Rua: TEdit;
    Estado: TEdit;
    Cidade: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    chkStreetView: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btLimpaClick(Sender: TObject);
    procedure WebBrowserCommandStateChange(ASender: TObject; Command: Integer;  Enable: WordBool);
    procedure btLocalizaClick(Sender: TObject);
    procedure Lista_LocalizacaoChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure LocalizaEnderecoClick(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    procedure chkStreetViewClick(Sender: TObject);
  private
    { Private declarations }
    HTMLWindow2 : IHTMLWindow2;
    ADocument   : IHTMLDocument2;
    ABody       : IHTMLElement2;
    procedure PegaCoordenadas;
    procedure AdicionaLatitudeLongitude(const Lat, Long: String);
    function GetIdValue(const Id: String): String;
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

const
  HTMLStr: AnsiString = '<html> ' +
                        '    <head> ' +
                        '        <meta name="viewport" content="initial-scale=1.0, user-scalable=yes" /> ' +

                        '        <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false&language=pt-BR"></script> ' +

                        '        <script type="text/javascript"> ' +
                        '            var geocoder; ' +
                        '            var map; ' +
                        '            var markersArray = [];' +

                        '            function getLocation() { ' +
                        '                if (navigator.geolocation) { ' +
                        '                    navigator.geolocation.getCurrentPosition(showPosition); ' +
                        '                } else { ' +
                        '                    initialize(-27.105130484209766, -52.614126205444336);' +
                        '                } ' +
                        '            } ' +

                        '            function showPosition(position) { ' +
                        '                initialize(position.coords.latitude, position.coords.longitude); ' +
                        '            }' +

                        '            function initialize(lat, lng) { ' +
                        '                geocoder = new google.maps.Geocoder();'+
                        '                var latlng = new google.maps.LatLng(lat, lng); ' +
                        '                var myOptions = { ' +
                        '                    zoom: 13, ' +
                        '                    center: latlng, ' +
                        '                    mapTypeId: google.maps.MapTypeId.ROADMAP ' +
                        '                }; ' +
                        '                map = new google.maps.Map(document.getElementById("map_canvas"), myOptions); ' +
                        '                map.set("streetViewControl", false);' +
                        '                google.maps.event.addListener(map, "click", ' +
                        '                    function(event) {' +
                        '                        document.getElementById("LatValue").value = event.latLng.lat(); ' +
                        '                        document.getElementById("LngValue").value = event.latLng.lng(); ' +
                        '                        PutMarker(document.getElementById("LatValue").value, document.getElementById("LngValue").value,"") ' +
                        '                    } ' +
                        '                ); ' +
                        '            } ' +

                                     // Localiza um endereço a partir de uma pesquisa
                        '            function codeAddress(address) { ' +
                        '                if (geocoder) {' +
                        '                    geocoder.geocode( { address: address}, function(results, status) { ' +
                        '                        if (status == google.maps.GeocoderStatus.OK) {' +
                        '                            map.setCenter(results[0].geometry.location);' +
                        '                            document.getElementById("LatValue").value = results[0].geometry.location.lat(); ' +
                        '                            document.getElementById("LngValue").value = results[0].geometry.location.lng(); ' +
                        '                            PutMarker(results[0].geometry.location.lat(), results[0].geometry.location.lng(), results[0].geometry.location.lat()+","+results[0].geometry.location.lng());'+
                        '                        } else {' +
                        '                            alert("Geocode não foi bem sucedido pelo seguinte motivo: " + status);' +
                        '                        }' +
                        '                    });' +
                        '                }' +
                        '            }' +

                                     // Posiciona o mapa em determinado ponto a partir da latitude e longitude informadas
                        '            function GotoLatLng(Lat, Lng) { ' +
                        '                var latlng = new google.maps.LatLng(Lat, Lng);' +
                        '                map.setCenter(latlng);' +
                        '            }' +

                                     // Limpa os marcadores do mapa e também as informações de latitude e longitude
                        '            function ClearMarkers() {  ' +
                        '                if (markersArray) {        ' +
                        '                    for (i in markersArray) {  ' +
                        '                        markersArray[i].setMap(null); ' +
                        '                    } ' +
                        '                } ' +
                        '                document.getElementById("LatValue").value = "";' +
                        '                document.getElementById("LngValue").value = "";' +
                        '            }  ' +

                                     // Adiciona um marcador no mapa e as coordenadas no array
                        '            function PutMarker(Lat, Lang, Msg) { ' +
                        '                var latlng = new google.maps.LatLng(Lat, Lang);' +
                        '                var marker = new google.maps.Marker({' +
                        '                    position: latlng, ' +
                        '                    map: map,' +
                        '                    title: Msg + " (" + Lat + "," + Lang + ")"' +
                        '                }); ' +
                        '                markersArray.push(marker); ' +
                        '                index = (markersArray.length % 10);' +
                        '                if (index==0) { index=10 } ' +
                        '                icon = "http://www.google.com/mapfiles/kml/paddle/"+index+"-lv.png"; ' +
                        '                marker.setIcon(icon); ' +
                        '            }' +

                        '            function StreetViewOn() { map.set("streetViewControl", true); }' +

                        '            function StreetViewOff() { map.set("streetViewControl", false); }' +

                        '        </script> ' +

                        '    </head> ' +
                        '    <body onload="getLocation()"> ' +
                        '        <div id="map_canvas" style="width:100%; height:100%"></div> ' +
                        '        <div id="latlong"> ' +
                        '            <input type="hidden" id="LatValue" >' +
                        '            <input type="hidden" id="LngValue" >' +
                        '        </div>  ' +
                        '    </body> ' +
                        '</html> ';

procedure TFrmMain.FormCreate(Sender: TObject);
var
  Stream: TMemoryStream;
begin
  WebBrowser.Navigate('about:blank');
  if Assigned(WebBrowser.Document) then
  begin
    Stream := TMemoryStream.Create;
    try
      Stream.WriteBuffer(Pointer(HTMLStr)^, Length(HTMLStr));
      //aStream.Write(HTMLStr[1], Length(HTMLStr));
      Stream.Seek(0, soFromBeginning);
      (WebBrowser.Document as IPersistStreamInit).Load(TStreamAdapter.Create(Stream));
    finally
      Stream.Free;
    end;
    HTMLWindow2 := (WebBrowser.Document as IHTMLDocument2).parentWindow;
  end;
end;


procedure TFrmMain.WebBrowserCommandStateChange(ASender: TObject; Command: Integer; Enable: WordBool);
begin
  if TOleEnum(Command) <> CSC_UPDATECOMMANDS then
    Exit;

  ADocument := WebBrowser.Document as IHTMLDocument2;
  if not Assigned(ADocument) then
    Exit;

  if not Supports(ADocument.body, IHTMLElement2, ABody) then
    Exit;

  PegaCoordenadas;
end;

function TFrmMain.GetIdValue(const Id: String): String;
var
  i        : Integer;
  Tag      : IHTMLElement;
  TagsList : IHTMLElementCollection;
begin
  Result   := '';
  TagsList := ABody.getElementsByTagName('input');

  for i := 0 to TagsList.Length - 1 do
  begin
    Tag := TagsList.item(i, EmptyParam) as IHTMLElement;

    if CompareText(Tag.id, Id) = 0 then
      Result := Tag.getAttribute('value', 0);
  end;
end;

procedure TFrmMain.AdicionaLatitudeLongitude(const Lat, Long: String);
var
  Item: TListItem;
begin
  if (Lat <> '') and (Long <> '') then
  begin
    Item := Lista_Localizacao.Items.Add;
    Item.Caption := Lat;
    Item.SubItems.Add(Long);
    Item.MakeVisible(False);
  end;
end;

procedure TFrmMain.btLimpaClick(Sender: TObject);
begin
  // Executa a função em Javascript para limpar os marcadores do mapa e limpa o Listview
  HTMLWindow2.execScript('ClearMarkers()', 'JavaScript');
  Lista_Localizacao.Items.Clear;
  Latitude.Text  := '';
  Longitude.Text := '';
end;

procedure TFrmMain.btLocalizaClick(Sender: TObject);
begin
  // Executa a função em Javascript para posicionar o mapa passando latitude e longitude
  if (Latitude.Text <> '') and (Longitude.Text <> '') then
    HTMLWindow2.execScript(Format('GotoLatLng(%s,%s)', [Latitude.Text, Longitude.Text]), 'JavaScript');
end;

procedure TFrmMain.Lista_LocalizacaoChange(Sender: TObject; Item: TListItem; Change: TItemChange);
begin
  if Assigned(Lista_Localizacao.Selected) then
  begin
    Latitude.Text  := Lista_Localizacao.Selected.Caption;
    Longitude.Text := Lista_Localizacao.Selected.SubItems[0];
  end;
end;

procedure TFrmMain.LocalizaEnderecoClick(Sender: TObject);
var
  Consulta: String;
begin
  Consulta := '';

  // monta o texto do endereço para pesquisa
  if Cidade.Text <> '' then
    Consulta := Consulta + Cidade.Text;

  if Estado.Text <> '' then
    if Consulta = '' then
      Consulta := Consulta + Estado.Text
    else
      Consulta := Consulta + ',' + Estado.Text;

  if Rua.Text <> '' then
    if Consulta = '' then
      Consulta := Consulta + Rua.Text
    else
      Consulta := Consulta + ',' + Rua.Text;

  if Cep.Text <> '' then
    if Consulta = '' then
      Consulta := Consulta + Cep.Text
    else
      Consulta := Consulta + ',' + Cep.Text;

  if Consulta = '' then
  begin
    Application.MessageBox('Informe pelo menos um campo para pesquisa.', 'Erro', MB_ICONERROR + MB_OK + MB_DEFBUTTON1);
    Exit;
  end;

  // Executa a função em Javascript para localizar no mapa o endereço digitado
  HTMLWindow2.execScript(Format('codeAddress(%s)', [QuotedStr(Consulta)]), 'JavaScript');

  WebBrowserCommandStateChange(Self, 0, False);

  PegaCoordenadas;
end;

procedure TFrmMain.ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
begin
  HTMLWindow2.execScript('PutMarkerEvt()', 'JavaScript');
end;

procedure TFrmMain.chkStreetViewClick(Sender: TObject);
begin
  if chkStreetView.Checked then
    HTMLWindow2.execScript('StreetViewOn()', 'JavaScript')
  else
    HTMLWindow2.execScript('StreetViewOff()', 'JavaScript');
end;

procedure TFrmMain.PegaCoordenadas;
var
  i    : Integer;
  Lat,
  Long : String;
begin
  // Tenta pegar os valores de latitude e longitude
  Lat  := GetIdValue('LatValue');
  Long := GetIdValue('LngValue');

  if (Lat <> '') and (Long <> '') and ((Lat <> Latitude.Text) or (Long <> Longitude.Text)) then
  begin
    // Se conseguiu pegar, adiciona no Listview os valores
    for i := 1 to Lista_Localizacao.Items.Count do
    begin
      // Se já está na lista, não adiciona
      if (Lat = Lista_Localizacao.Items[i - 1].Caption) and (Long = Lista_Localizacao.Items[i - 1].SubItems[0]) then
        Exit;
    end;

    Latitude.Text  := Lat;
    Longitude.Text := Long;
    AdicionaLatitudeLongitude(Lat, Long);
  end;
end;

end.
