<!DOCTYPE html>
<html lang="en">

  <?php include("./includes/header.php");?>

  <body class="fixed-nav sticky-footer bg-dark" id="page-top">

    <?php include("./includes/navigation.php");?>

    <div class="content-wrapper">

      <div class="container-fluid">
      
      <?php 
        $page = "./pages/main.php";
        if (isset($_GET["currentPage"])) {
          $page = "./pages/".$_GET["currentPage"];
        }
        include($page);
      ?>
        
      </div>
      <!-- /.container-fluid -->

    </div>
    <!-- /.content-wrapper -->

    <?php include("./includes/footer.php");?>

  </body>

</html>
