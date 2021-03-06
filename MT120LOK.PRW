#include "Protheus.ch"

#DEFINE ENTER Chr(13)+Chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �mt120LOK  �Autor  �Paulo Bindo         � Data �  03/08/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � PONTO DE ENTRADA NA VAIDACAO DA LINHA DO PEDIDO DE COMPRAS ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION MT120LOK()

	Local cProd 	:= Buscacols("C7_PRODUTO")
	Local lRet		:= .T.
	Local aArea		:= GetArea()

	//NA EXCLUSAO SAI DA ROTINA
	If !(INCLUI .Or. ALTERA) .Or. IsInCallStack("U_COMMI005")
		Return(lRet)
	EndIf



	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial()+cProd)
	If SB1->B1_TIPO == "MO"
		MsgStop("n�o � permitido um Pedido de Compras para mao de obra","MT120LOK")
		RestArea(aArea)
		lRet := .F.
	EndIf


	RestArea(aArea)
Return(lRet)
