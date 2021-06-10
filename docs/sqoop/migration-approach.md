# Migration Approach

Azure has several landing targets for Apache Sqoop. Depending on requirements and product features, customers can choose between Azure IaaS, HDInsight or Data Factory.  

Landing Targets for Apache Sqoop on Azure
![Landing Targets for Apache HBase on Azure](../images/flowchart-sqoop-azure-landing-targets.png)

- [Azure IaaS](#lift-and-shift-migration-to-azure-iaas)
- [Azure Cosmos DB (SQL API)](#migrating-apache-hbase-to-azure-cosmos-db-sql-api)


## Lift and shift migration to Azure IaaS  

オンプレミスで稼働するSqoopの移行先として、Azure IaaSの仮想マシンを選択する場合は、完全に同一のバージョンのSqoopを使用することができ、完全にコントロールできる環境を構築することができます。それゆえに、Sqoopのソフトウェアそれ自体に対する変更をしない方法が利用可能です。SqoopはHadoop Clusterと協調動作するため、Hadoop Clusterと一緒に移行されるのが通常です。
Lift and ShiftとしてHadoop Clusterを移行するガイドとして以下が利用可能です。移行対象のサービスに応じて参照してください。

- [Apache Hive](https://github.com/Azure/Hadoop-Migrations/blob/main/docs/hive/migration-approach.md#lift-and-shift---iaas)
- [Apache Ranger](https://github.com/Azure/Hadoop-Migrations/blob/main/docs/ranger/migration-approach.md#lift-and-shift--iaas-infrastructure-as-a-service)
- [Apache HBase](https://github.com/Azure/Hadoop-Migrations/blob/main/docs/hbase/migration-approach.md#lift-and-shift-migration-to-azure-iaas)


### 移行前の準備

#### プランニング
既存のSqoopの移行の前の準備として、以下の情報を事前に集めてください。これらは移行先の仮想マシンのサイズの決定や用意するソフトウェアコンポーネントやネットワーク構成の計画などに役立つでしょう。

|Item|Background|
|----|----------|
|現状のホストのサイズ|Sqoopクライアントやサーバが稼働しているホストまたは仮想マシンのCPU, Memory, Diskなどの情報を取得します。これによりAzure仮想マシンで必要となるベースのサイズを見積もることができます。|
|ホストやアプリケーションのメトリック|次にSqoopのクライアントを動作させているマシンのメトリック情報 (CPU, Memory, Diskなど) を取得し、実際に使用しているリソースを見積もってください。ホストに割り当てられているサイズに対して実際に使用しているリソースが少ない場合には、Azureへの移行時にダウンサイジングをすることができる可能性があります。必要なリソース量が特定できたら、[Azureの仮想マシンのサイズ](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes)を参考に移行先の仮想マシンのタイプを選定してください。|
|Sqoopのバージョン|新しいAzureの仮想マシンにインストールするSqoopのバージョンを決定するために、既存のSqoopのバージョンを確認します。ClouderaやHortonworksなどのディストリビューションを使用している場合、そのディストリビューションのバージョンに依存してコンポーネントのバージョンが決定されるでしょう。|
|稼働させているジョブ、スクリプト|稼働しているSqoopジョブを特定します。どのようなジョブが稼働しているか。どのように記述されており、どのようにジョブがスケジューリングされているかを特定します。そのスクリプトやスケジューリングやそれらのジョブに依存する処理などは移行対象として検討されることができます。|
|接続するRDB|SqoopジョブのImport/Exportに指定されている接続先のRDBMSをすべて特定する必要があります。それらが特定できたら、SqoopをAzure仮想マシンに移行した後に、それらのデータベースに対して接続することができるかを確認する必要があります。接続先のいくつかのデータベースが依然としてオンプレミスにある場合、オンプレミスとAzure間のネットワーク接続が必要になります。ネットワーク接続に関するトピックは[ネットワーク接続]()セクションを参照してください。|
|プラグインの有無|Sqoopのカスタムプラグインを使用している場合は、そのプラグインを特定する必要があります。それらは移行対象になることができるでしょう。|
|BC and DR|Sqoopの実行に対して何らかの障害対策をしている場合は、それをAzure上で実現するかどうかを確認する必要があります。例えば2つのノードでActive/Stand-byの構成をしている場合、Sqoopクライアント用のAzure仮想マシンを2台準備して同じ構成を取るかどうかなどです。また、DRを構成している場合も同様です。|

#### ネットワーク接続

接続先のいくつかのデータベースが依然としてオンプレミスにある場合、オンプレミスとAzure間のネットワーク接続が必要になります。
オンプレミスとAzure間をプライベートのネットワークで接続するには、主に以下の2つのオプションがあります。

- VPN
  Azure VPN Gatewayを使用して、パブリック インターネットを介して Azure 仮想ネットワークとオンプレミスの場所の間で暗号化されたトラフィックを送信することができます。これは安価で容易にセットアップができるメリットがあります。しかしながら、パブリックインターネットを介した暗号化接続のため、通信自体の帯域幅が保証されません。帯域幅を保証する必要がある場合は次のExpressRouteを選択する必要があります。VPNを使用する場合は、[VPNのデザインに関するドキュメント](https://docs.microsoft.com/en-us/azure/vpn-gateway/design)を確認し、必要な構成を検討してください。
- ExpressRoute  
  ExpressRouteを利用すると、接続プロバイダーが提供するプライベート接続を介して、オンプレミスのネットワークをAzureやMicrosoft 365と接続することができます。ExpressRouteはパブリックインターネットを経由しないため、インターネット経由の接続に比べて安全性や信頼性が高く、レイテンシーも安定します。また、購入する回線の帯域幅オプションにより、安定したトラフィックを保証できます。詳しくは[ExpressRouteのドキュメント](https://docs.microsoft.com/en-us/azure/expressroute/expressroute-introduction)を参照してください。

VPNのオプション及びExpressRouteの違いについては、こちらの[プランニングテーブル](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways#configuring)を参照してください。


もし何らかの理由 (例えば企業のネットワークのポリシーなど) によって、これらのプライベート接続を構成することができない場合、移行先としてAzure Data Factoryも検討してみてください。Azure Data FactoryのSelf-hosted Integration Runtimeを使用すると、プライベートネットワークを構成すること無しに、安全にオンプレミスからAzureにデータを転送することができます。

### Sqoop Migration

オンプレミスのSqoopをAzure
移行する対象
- config files  
  Sqoopのconfig filesを特定し、それらを移行対象に含めます。環境による際はありますが、主に以下のようなファイルがあります。
  - sqoop-site.xml
  - sqoop-env.xml
  - password-file
  - oraoop-site.xml -- Oraoopを使用している場合

- Saved Jobs
  `sqoop job --create` コマンドでSaved JobsをSqoop metastoreに保存している場合はこれらを移行する必要があります。metastoreの保存先はsqoop-site.xmlに定義されているため、その設定を参照のうえ、場所を特定してください。共有メタストアの設定がされていない場合、metastoreを実行しているユーザーのホームディレクトリの.sqoopディレクトリ内にこれらが保存されていることがあります。

実際に保存されているジョブの情報を調べるには、以下のコマンドを利用することができます。

保存されたジョブリストを取得する

sqoop job --list

保存されたジョブのパラメータを表示する

sqoop job --show <job-id>

- Scripts  
  Sqoopを実行するスクリプトファイルを持っている場合は、これらのファイルを移行する必要があります。必要となるすべてのファイルを特定して移行してください。

- スケジューラー  
  Sqoopの実行をスケジューリングしている場合は、そのスケジューラーを特定する必要があります。例えば、Linuxのcron jobでスケジューリングしているのか、何らかのジョブ管理ツールを使用しているのかなどです。スケジューラーを特定したら、そのスケジューラーもAzureに移行することができるのかを検討する必要があります。

- plug-ins  
  例えば外部データベースへのコネクタなど、Sqoopのカスタムプラグイン使用している場合は、それらを移行する必要があります。パッチファイルを作成している場合は、Azure VMにインストールしたSqoopに対してパッチを適用します。


## Migration to HDInsight

Sqoopそれ自体だけをAzureに移行するのではなく、典型的にはSqoopを含むBigDataワークロードAzureに移行します。そのため、BigDataワークロードをHDInsightに移行するためには、下記のガイドを参照してください。
https://azure.microsoft.com/en-us/resources/migrating-big-data-workloads-hdinsight/

HDInsightで利用可能なコンポーネントのバージョンは以下を参照してください。
- [HDInsight 4.0 component versions](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-40-component-versioning)
- [HDInsight 3.6 component versions](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-36-component-versioning)

MigrationについてはLift and Shift migration to Azure IaaSのセクションを参照してください。

## Migration to Data Factory

Azure Data FactoryはPaaS型のETLサービスです。Data Factoryはサーバレスであり、フルマネージドのサービスです。利用者はインフラの管理をする必要はありません。データのボリュームなどに応じてオンデマンドでスケールすることができ、利用した分が課金されるモデルです。直感的な編集ができるGUIを備えており、必要に応じてPython, .NET, ARMを使った開発が可能です。

### Resource mapping

### Connection to Databases

### Connect to Databases on premise
Self-hosted Integration Runtime

### Performance of data copy
DIU

### Applying SQL

### Data Transformation
Data Flow, Spark Notebook

### Data format
- Text, Avro, JSON, ...

### Scheduling jobs
Trigger

### Network options

#### Private Link

#### Managed Virtual Network
