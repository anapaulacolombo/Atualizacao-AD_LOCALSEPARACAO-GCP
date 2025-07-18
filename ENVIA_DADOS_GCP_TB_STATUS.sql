--ALTER SESSION SET CURRENT_SCHEMA= SANKHYA;

CREATE OR REPLACE PROCEDURE ENVIA_DADOS_GCP_TB_STATUS
as
BEGIN
    delete TB_STATUS_PEDIDOS_SKU
          where trunc(dtalter) BETWEEN TRUNC(SYSDATE,'MONTH')-90 AND TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS');
          COMMIT;

          insert into TB_STATUS_PEDIDOS_SKU ( EMPRESA, RAZAO_SOCIAL,NUNOTA_PEDIDO, DTNEG_PEDIDO, DHAPROVACAO_PEDIDO, CODPARC, NOMEPARC, CODPARCMATRIZ, NOMEPARCMATRIZ, PERC_SERVICOS,
          CODVENDEDOR, NOME_VENDEDOR, GRUPO_TOP, COD_TOP, DESC_TOP, COD_NATUREZA, DESCR_NATUREZA, CODTIPOPARC, DESCTIPOPARC,PENDENTE,VALOR_NF , VALOR_FRETE,VALOR_ICMS,
          VALOR_IPI,VALOR_ST,VALOR_DESCONTO,VLR_NF_SEM_IMP, Royalties_Taxa, NUMNOTA_NF, DT_FATURAMENTO_NF, STATUS,SEQ, CODPROD,  DESCRPROD, MARCA, QTDNEG, VLRUNIT, VLRTOT,
          VALOR_CAB_PEDIDO, DTALTER, DTINSERT, LOCALSEPARACAO)

          select A.EMPRESA, A.RAZAO_SOCIAL, A.NUNOTA_PEDIDO, A.DTNEG_PEDIDO, A.DHAPROVACAO_PEDIDO, A.CODPARC, A.NOMEPARC, A.CODPARCMATRIZ, A.NOMEPARCMATRIZ, A.PERC_SERVICOS,
          A.CODVENDEDOR, A.NOME_VENDEDOR, A.GRUPO_TOP, A.COD_TOP, A.DESC_TOP, A.COD_NATUREZA, A.DESCR_NATUREZA, A.CODTIPOPARC, A.DESCTIPOPARC, A.PENDENTE, A.VALOR_NF , A.VALOR_FRETE, A.VALOR_ICMS,
          A.VALOR_IPI, A.VALOR_ST, A.VALOR_DESCONTO, A.VLR_NF_SEM_IMP, A.Royalties_Taxa, nvl(A.NUMNOTA_NF,0) NUMNOTA_NF, A.DT_FATURAMENTO_NF, A.STATUS, A.SEQ, A.CODPROD, A.DESCRPROD, A.MARCA, A.QTDNEG, A.VLRUNIT, A.VLRTOT,
          A.VALOR_CAB_PEDIDO, A.DTALTER, sysdate, A.AD_LOCALSEPARACAO
          from STATUS_PEDIDOS_SKU A
          LEFT JOIN TB_STATUS_PEDIDOS_SKU B ON A.EMPRESA = B.EMPRESA AND A.NUNOTA_PEDIDO = B.NUNOTA_PEDIDO AND A.CODPARC = B.CODPARC
                               AND A.CODPROD = B.CODPROD AND A.SEQ = B.SEQ-- AND nvl(A.NUMNOTA_NF,0) = nvl(B.NUMNOTA_NF,0)
          where trunc(A.dtalter) BETWEEN TRUNC(SYSDATE,'MONTH')-90 AND TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS')
          AND B.NUNOTA_PEDIDO IS NULL;

          COMMIT;


          /*Criada mais uma condi  o caso haja altera  o nos pedidos em um per odo de D-90 */

          FOR C5 IN (select A.EMPRESA, A.RAZAO_SOCIAL, A.NUNOTA_PEDIDO, A.DTNEG_PEDIDO, A.DHAPROVACAO_PEDIDO, A.CODPARC, A.NOMEPARC, A.CODPARCMATRIZ, A.NOMEPARCMATRIZ, A.PERC_SERVICOS,
          A.CODVENDEDOR, A.NOME_VENDEDOR, A.GRUPO_TOP, A.COD_TOP, A.DESC_TOP, A.COD_NATUREZA, A.DESCR_NATUREZA, A.CODTIPOPARC, A.DESCTIPOPARC, A.PENDENTE, A.VALOR_NF , A.VALOR_FRETE, A.VALOR_ICMS,
          A.VALOR_IPI, A.VALOR_ST, A.VALOR_DESCONTO, A.VLR_NF_SEM_IMP, A.Royalties_Taxa, nvl(A.NUMNOTA_NF,0) NUMNOTA_NF, A.DT_FATURAMENTO_NF, A.STATUS, A.SEQ, A.CODPROD, A.DESCRPROD, A.MARCA, A.QTDNEG, A.VLRUNIT, A.VLRTOT,
          A.VALOR_CAB_PEDIDO, A.DTALTER, sysdate, A.AD_LOCALSEPARACAO
          from STATUS_PEDIDOS_SKU A
          LEFT JOIN TB_STATUS_PEDIDOS_SKU B ON A.EMPRESA = B.EMPRESA AND A.NUNOTA_PEDIDO = B.NUNOTA_PEDIDO AND A.CODPARC = B.CODPARC
                               AND A.CODPROD = B.CODPROD AND A.SEQ = B.SEQ
          where trunc(A.dtalter) BETWEEN TO_CHAR(SYSDATE-90,'DD/MM/YYYY') AND TO_DATE(TO_CHAR(TRUNC(SYSDATE,'MONTH')-1, 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS')
          AND NOT B.NUNOTA_PEDIDO IS NULL
          )LOOP
            UPDATE TB_STATUS_PEDIDOS_SKU A SET A.VALOR_NF = C5.VALOR_NF,
                      A.VALOR_FRETE = C5.VALOR_FRETE,A.VALOR_ICMS = C5.VALOR_ICMS,A.VALOR_IPI = C5.VALOR_IPI,A.VALOR_ST = C5.VALOR_ST,
                       A.VALOR_DESCONTO = C5.VALOR_DESCONTO, A.VLR_NF_SEM_IMP = C5.VLR_NF_SEM_IMP, A.Royalties_Taxa = C5.Royalties_Taxa,
                       A.DT_FATURAMENTO_NF = C5.DT_FATURAMENTO_NF, A.STATUS = C5.STATUS, A.QTDNEG = C5.QTDNEG, A.NUMNOTA_NF = nvl(C5.NUMNOTA_NF,0),
                       A.VLRUNIT = C5.VLRUNIT, A.VLRTOT = C5.VLRTOT,A.VALOR_CAB_PEDIDO = C5.VALOR_CAB_PEDIDO, A.DTALTER = C5.DTALTER,
                       A.LOCALSEPARACAO = C5.AD_LOCALSEPARACAO
            WHERE A.EMPRESA = C5.EMPRESA AND A.NUNOTA_PEDIDO = C5.NUNOTA_PEDIDO AND A.CODPARC = C5.CODPARC
                               AND A.CODPROD = C5.CODPROD AND A.SEQ = C5.SEQ;
            COMMIT;
          END LOOP;      

END;
