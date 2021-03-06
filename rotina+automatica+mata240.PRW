#INCLUDE "protheus.ch"
#DEFINE ENTER Chr(13)+Chr(10)
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RAMATA240 � Autor � AP6 IDE            � Data �  15/02/22   ���
�������������������������������������������������������������������������͹��
���Descricao � ROTINA AUTOMATICA MOVIMENTACAO INTERNA                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RAMATA240()


If RetCodUsr() # "000000"
	MsgStop("Usuario sem premissao","RAMATA240")
	Return
EndIf


cMensagem := " Este programa ira executar comando"+ENTER
cMensagem += " para Expemplo rotina automatica movimentacao interna"


If MsgYesNo(cMensagem,"RAMATA240")
	Processa( {|| ra240() } )
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RAMATA240�Autor  �Microsiga           � Data �  12/28/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ra240()

	
	//TRANSFERIR DO NL PARA 01 TODOS OS SALDOS DE MAIS DE 1 LOCALIZACAO
	cQuery := " SELECT * FROM "+RetSqlName("SB2")+" WHERE B2_FILIAL = '"+cFilAnt+"' AND B2_QATU > 0 AND D_E_L_E_T_ <> '*'"
	
	MemoWrite("RAMATA240.SQL",cQuery)
	dbUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TRB", .F., .T.)
	
	Count To nRec
	
	If nRec > 0
		
		ProcRegua(nRec)
		dbSelectArea("TRB")
		dbGoTop()
		
		While !Eof()
			IncProc("REQUISITANDO ITENS ESTOQUE ")
			
			
			cNumseq := ProxNum()
			cNumDoc  := NextNumero("SD3",2,"D3_DOC",.T.)//BUSCA NUMERACAO DO SD3
			nQuant := 1

			aReg := { {"D3_COD"	,TRB->B2_COD	,Nil},;
			{"D3_LOCAL"		,TRB->B2_LOCAL		,Nil},;
			{"D3_NUMSEQ"	,cNumSeq 			,Nil},;
			{"D3_DOC"		,cNumDoc 			,Nil},;
			{"D3_LOCALIZ"	,""					,Nil},;
			{"D3_QUANT"		,nQuant				,Nil},;
			{"D3_TM"		,"501" 				,Nil},;
			{"D3_OBS"		,"CONSUMO INTERNO RAMATA240"	,Nil}}
			
			
			lMsErroAuto := .F.
			//GERA O TITULO NO SD3
			MSExecAuto({|x,y,z| MATA240(x,y,z)},aReg,,3)
			Conout("Requisicao interna efetuada "+cNumDoc)
			If lMsErroAuto
				Mostraerro()
			EndIf
			
			
			dbSelectArea("TRB")
			dbSkip()
		End
	EndIf
	TRB->(dbCloseArea())
	



Return

